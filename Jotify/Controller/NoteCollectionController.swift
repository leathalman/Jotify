//
//  NoteCollectionController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit
import SwiftUI
import UserNotifications

/// The Notes grid: a compositional layout fed by a diffable data source,
/// native context menus, and the collection view's own multi-select.
class NoteCollectionController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    /// Latest version of every note, keyed by Firestore document ID.
    private var notesByID: [String: FBNote] = [:]

    /// Update the grid when the model changes.
    var noteCollection: NoteCollection? {
        didSet { notesDidChange() }
    }
    private var hasCleanedUpOldNotes = false

    /// Notes matching the search bar text.
    var filteredNotes: [FBNote] = []

    /// What the grid shows right now: search results or every note.
    var displayedNotes: [FBNote] {
        isFiltering ? filteredNotes : (noteCollection?.FBNotes ?? [])
    }

    // MARK: Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // iOS 26: search and compose live in the bottom toolbar.
        if #available(iOS 26.0, *) {
            navigationController?.setToolbarHidden(false, animated: animated)
        }
        enableAutomaticStatusBarStyle()
        resetAppBadgeIfAllRemindersCleared()
    }

    override func viewDidLoad() {
        let vdlID = Signposts.begin("NoteCollection.viewDidLoad")
        defer { Signposts.end("NoteCollection.viewDidLoad", id: vdlID) }
        super.viewDidLoad()
        buildViewHierarchy()
        configureDataSource()
        setupSearchController()
        setupNavigationBar()
        applySnapshot(animated: false)

        NotificationCenter.default.addObserver(self, selector: #selector(pureDarkModeChanged), name: NSNotification.Name(rawValue: "updatePureDarkMode"), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setSelecting(false)
    }

    // MARK: Views

    private func buildViewHierarchy() {
        view.backgroundColor = ColorManager.bgColor

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ColorManager.bgColor
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.allowsSelectionDuringEditing = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.keyboardDismissMode = .interactive
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /// Adaptive grid: as many ~170pt columns as fit (at least two), with
    /// card height scaled for the user's text size.
    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let spacing: CGFloat = 12
            let width = environment.container.effectiveContentSize.width
            let columns = max(2, Int((width - spacing) / (170 + spacing)))
            let height = UIFontMetrics(forTextStyle: .body)
                .scaledValue(for: 132, compatibleWith: environment.traitCollection)

            let itemWidth = floor((width - spacing * CGFloat(columns + 1)) / CGFloat(columns))

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemWidth),
                                                                heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)),
                subitems: [item])
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            return section
        }
    }

    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<SavedNoteCell, String> { [weak self] cell, _, id in
            guard let note = self?.notesByID[id] else { return }
            cell.configure(with: note)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, id in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: id)
        }
    }

    func setupNavigationBar() {
        navigationItem.title = "Notes"
        navigationItem.setHidesBackButton(true, animated: false)

        let settings = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(handleLeftNavButton))
        settings.accessibilityLabel = "Settings"
        navigationItem.leftBarButtonItem = settings

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        if #available(iOS 26.0, *) {
            // Search field and compose button share the bottom toolbar, as
            // in Notes and Mail; the search field expands when tapped.
            navigationItem.searchBarPlacementAllowsToolbarIntegration = true
            navigationItem.preferredSearchBarPlacement = .integrated
        } else {
            navigationItem.rightBarButtonItem = composeItem
        }
        toolbarItems = defaultToolbarItems
    }

    private lazy var composeItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(handleRightNavButton))
        item.accessibilityLabel = "New Note"
        return item
    }()

    /// Bottom toolbar outside selection mode (iOS 26): search, then compose.
    private var defaultToolbarItems: [UIBarButtonItem]? {
        guard #available(iOS 26.0, *) else { return nil }
        return [navigationItem.searchBarPlacementBarButtonItem, .flexibleSpace(), composeItem]
    }

    // MARK: Data

    private func notesDidChange() {
        let notes = noteCollection?.FBNotes ?? []
        let previous = notesByID
        notesByID = Dictionary(notes.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

        if isFiltering {
            filteredNotes = matches(for: searchText)
        }

        if isViewLoaded {
            // Rebind cells whose note changed in place (edited text, new
            // color, reminder set) without reloading the whole grid.
            let changed = notes.filter { previous[$0.id] != nil && previous[$0.id] != $0 }.map(\.id)
            applySnapshot(reconfiguring: changed)
        }

        // Run the "delete notes older than 30 days" pass once, when the
        // first snapshot arrives.
        if !hasCleanedUpOldNotes, noteCollection != nil {
            hasCleanedUpOldNotes = true
            cleanupOldNotes()
        }
    }

    func applySnapshot(reconfiguring changed: [String] = [], animated: Bool = true) {
        guard let dataSource else { return }
        var seen = Set<String>()
        let ids = displayedNotes.map(\.id).filter { seen.insert($0).inserted }

        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(ids)
        let present = Set(ids)
        snapshot.reconfigureItems(changed.filter { present.contains($0) })
        dataSource.apply(snapshot, animatingDifferences: animated && view.window != nil)

        updateEmptyState()
        updateToolbar()
    }

    /// Loading, empty and no-results states, as the collection view's
    /// background so the docked search bar stays usable on top of them.
    private func updateEmptyState() {
        var config: UIContentUnavailableConfiguration?
        if noteCollection == nil {
            config = .loading()
        } else if isFiltering, filteredNotes.isEmpty {
            config = .search()
        } else if !isFiltering, noteCollection?.FBNotes.isEmpty ?? true {
            var empty = UIContentUnavailableConfiguration.empty()
            empty.image = UIImage(systemName: "square.and.pencil")
            empty.imageProperties.tintColor = .brandCoral
            empty.text = "No Notes Yet"
            config = empty
        }

        if let config {
            if let existing = collectionView.backgroundView as? UIContentUnavailableView {
                existing.configuration = config
            } else {
                collectionView.backgroundView = UIContentUnavailableView(configuration: config)
            }
        } else {
            collectionView.backgroundView = nil
        }
    }

    func note(at indexPath: IndexPath) -> FBNote? {
        dataSource.itemIdentifier(for: indexPath).flatMap { notesByID[$0] }
    }

    // MARK: Actions

    @objc func handleLeftNavButton() {
        playHapticFeedback()
        present(SettingsView.makeController(noteCount: noteCollection?.FBNotes.count ?? 0), animated: true)
    }

    @objc func handleRightNavButton() {
        (rootViewController as? PageBoyController)?.scrollToWriteNoteController()
        playHapticFeedback()
    }

    private func open(_ note: FBNote) {
        let controller = EditingController()
        controller.noteCollection = noteCollection
        controller.hidesBottomBarWhenPushed = true
        EditingData.currentNote = note
        navigationController?.pushViewController(controller, animated: true)
    }

    private func share(_ note: FBNote, from indexPath: IndexPath) {
        let activityVC = UIActivityViewController(activityItems: [note.content], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.addToReadingList]
        // iPad shows the share sheet as a popover anchored on the card.
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = collectionView.cellForItem(at: indexPath) ?? view
        }
        present(activityVC, animated: true)
    }

    /// Deletes notes on the server and clears any reminders they had.
    private func delete(_ notes: [FBNote]) {
        let center = UNUserNotificationCenter.current()
        for note in notes {
            if (note.reminderTimestamp ?? 0) > 0 {
                if let reminder = note.reminder, !reminder.isEmpty {
                    center.removePendingNotificationRequests(withIdentifiers: [reminder])
                }
                //already delivered but not opened: it counted toward the badge
                if (note.reminderTimestamp ?? 0) < Date.timeIntervalSinceReferenceDate {
                    UIApplication.shared.decrementBadge()
                }
            }
            DataManager.deleteNote(docID: note.id) { _ in }
        }
    }

    // MARK: Multi-select

    /// Enters or leaves selection mode, optionally pre-selecting a card.
    func setSelecting(_ selecting: Bool, startingWith indexPath: IndexPath? = nil) {
        guard collectionView != nil else { return }
        if selecting == collectionView.isEditing {
            if let indexPath { collectionView.selectItem(at: indexPath, animated: true, scrollPosition: []) }
            return
        }
        collectionView.isEditing = selecting
        if selecting, let indexPath {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        if selecting {
            updateToolbar()
        } else {
            setToolbarItems(defaultToolbarItems, animated: true)
        }
        // Before iOS 26 the toolbar only exists for selection mode.
        if #unavailable(iOS 26.0) {
            navigationController?.setToolbarHidden(!selecting, animated: true)
        }
    }

    private func updateToolbar() {
        guard collectionView?.isEditing == true else { return }
        let count = collectionView.indexPathsForSelectedItems?.count ?? 0
        let delete = UIBarButtonItem(title: count > 0 ? "Delete (\(count))" : "Delete", style: .plain, target: self, action: #selector(deleteSelectedNotes))
        delete.tintColor = .systemRed
        delete.isEnabled = count > 0
        setToolbarItems([
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endSelecting)),
            .flexibleSpace(),
            delete,
        ], animated: true)
    }

    @objc private func endSelecting() {
        setSelecting(false)
    }

    @objc func deleteSelectedNotes() {
        let notes = (collectionView.indexPathsForSelectedItems ?? []).compactMap(note(at:))
        delete(notes)
        setSelecting(false)
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playHapticFeedback()
        if collectionView.isEditing {
            updateToolbar()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            if let note = note(at: indexPath) { open(note) }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.isEditing { updateToolbar() }
    }

    // Two-finger pan across cards selects them, as in Mail and Files.
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setSelecting(true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard !collectionView.isEditing,
              indexPaths.count == 1,
              let indexPath = indexPaths.first,
              let note = note(at: indexPath) else { return nil }

        return UIContextMenuConfiguration(identifier: note.id as NSString, previewProvider: nil) { [weak self] _ in
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self?.share(note, from: indexPath)
            }
            let select = UIAction(title: "Select", image: UIImage(systemName: "checkmark.circle")) { _ in
                self?.setSelecting(true, startingWith: indexPath)
            }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self?.delete([note])
            }
            return UIMenu(children: [share, select, UIMenu(options: .displayInline, children: [delete])])
        }
    }

    // MARK: Housekeeping

    func resetAppBadgeIfAllRemindersCleared() {
        guard let notes = noteCollection?.FBNotes else { return }
        if !notes.contains(where: { ($0.reminderTimestamp ?? 0) > 0 }) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
    }

    func cleanupOldNotes() {
        guard UserDefaults.standard.bool(forKey: "deleteOldNotes"),
              let notes = noteCollection?.FBNotes else { return }
        let thirtyDays: TimeInterval = 30 * 24 * 60 * 60
        let now = Date.timeIntervalSinceReferenceDate
        for note in notes where now - note.timestamp > thirtyDays {
            DataManager.deleteNote(docID: note.id) { _ in }
        }
    }

    @objc func pureDarkModeChanged() {
        view.backgroundColor = ColorManager.bgColor
        collectionView.backgroundColor = ColorManager.bgColor
    }
}
