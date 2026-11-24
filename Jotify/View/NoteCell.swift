//
//  NoteCell.swift
//  Jotify
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

/// A note card in the Notes grid. The first line reads as a title, the
/// rest as a preview; selection while editing shows a checkmark badge
/// (driven by the collection view's own multi-select state).
class SavedNoteCell: UICollectionViewCell {

    // One size for the whole preview, top-pinned, at most four lines: every
    // card's text starts at the same height and ends with "…" if cut off.
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .subheadline)
            .scaledFont(for: .systemFont(ofSize: 15, weight: .medium))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let reminderIcon: UIImageView = {
        let config = UIImage.SymbolConfiguration(textStyle: .footnote)
        let view = UIImageView(image: UIImage(systemName: "bell.fill", withConfiguration: config))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private let selectionBadge: UIImageView = {
        let config = UIImage.SymbolConfiguration(textStyle: .title3)
        let view = UIImageView(image: UIImage(systemName: "circle", withConfiguration: config))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private var note: FBNote?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        contentView.addSubview(textLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(reminderIcon)
        contentView.addSubview(selectionBadge)

        let inset: CGFloat = 14
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -6),

            dateLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: reminderIcon.leadingAnchor, constant: -6),

            reminderIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            reminderIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),

            // Bottom corner, next to the date, so it never covers the text.
            selectionBadge.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            selectionBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])

        isAccessibilityElement = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with note: FBNote) {
        self.note = note
        let background = note.color.getColor()
        let foreground: UIColor = background.isDarkColor ? .white : .black

        contentView.backgroundColor = background
        textLabel.text = note.content.trimmingCharacters(in: .whitespacesAndNewlines)
        textLabel.textColor = foreground
        dateLabel.text = Self.shortDate(note.timestamp)
        dateLabel.textColor = foreground.withAlphaComponent(0.75)
        reminderIcon.tintColor = foreground.withAlphaComponent(0.75)
        selectionBadge.tintColor = foreground

        let hasReminder = (note.reminderTimestamp ?? 0) > 0
        reminderIcon.isHidden = !hasReminder

        accessibilityLabel = [note.content.isEmpty ? "Empty note" : note.content,
                              dateLabel.text,
                              hasReminder ? "Reminder set" : nil]
            .compactMap { $0 }
            .joined(separator: ", ")
        setNeedsUpdateConfiguration()
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        let config = UIImage.SymbolConfiguration(textStyle: .title3)
        selectionBadge.isHidden = !state.isEditing
        reminderIcon.alpha = state.isEditing ? 0 : 1
        selectionBadge.image = UIImage(systemName: state.isSelected ? "checkmark.circle.fill" : "circle",
                                       withConfiguration: config)
        // Dim the unselected cards slightly while picking, like Photos.
        contentView.alpha = state.isEditing && !state.isSelected ? 0.75 : 1
        accessibilityTraits = state.isSelected ? [.button, .selected] : .button
    }

    /// "3:41 PM" today, "Yesterday", "Mar 3" this year, "Mar 3, 2024" before.
    static func shortDate(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSinceReferenceDate: timestamp)
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, equalTo: .now, toGranularity: .year) {
            return date.formatted(.dateTime.month(.abbreviated).day())
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

