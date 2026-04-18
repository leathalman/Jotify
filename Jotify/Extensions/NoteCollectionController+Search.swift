//
//  NoteCollectionController+Search.swift
//  Jotify
//
//  Created by Harrison Leath on 5/3/21.
//

import UIKit

extension NoteCollectionController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        searchController.hidesNavigationBarDuringPresentation = false
        // Hide the inner clear-text X. iOS 26's automatic Cancel glass pill
        // handles dismissal, and users can backspace to clear — two X's in
        // the same control is visual clutter.
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.isActive = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        // Pin the search bar to the stacked position (below the title). iOS 26
        // otherwise places the bar near the bottom of the screen for no-tab-bar
        // apps, where the keyboard hides it.
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let query = searchText.lowercased()
        let errorNote: [FBNote] = [FBNote(content: "", timestamp: 0, id: "", color: "blue")]

        filteredNotes = (noteCollection?.FBNotes.filter { note in
            let matchesContent = note.content.lowercased().contains(query)
            let matchesDate = note.timestamp.getDate().lowercased().contains(query)
            switch searchScope {
            case .all: return matchesContent || matchesDate
            case .content: return matchesContent
            case .date: return matchesDate
            }
        }) ?? errorNote

        collectionView.reloadData()
    }

    // MARK: - Filter menu (iOS 26 UIMenu pattern)

    func makeFilterMenu() -> UIMenu {
        let actions = SearchScope.allCases.map { scope in
            UIAction(
                title: scope.title,
                state: searchScope == scope ? .on : .off
            ) { [weak self] _ in
                self?.searchScope = scope
            }
        }
        return UIMenu(title: "Search in", options: .singleSelection, children: actions)
    }

    func updateFilterMenu() {
        // Rebuild the menu so the checkmark (`.on` state) reflects the new
        // selection, and swap the icon to its filled variant when the filter
        // is narrower than "All".
        filterBarButton?.menu = makeFilterMenu()
        let icon = searchScope == .all
            ? "line.3.horizontal.decrease.circle"
            : "line.3.horizontal.decrease.circle.fill"
        filterBarButton?.image = UIImage(systemName: icon)
    }
    
    //true if the search bar is active and has search parameters (not empty)
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
}

extension NoteCollectionController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
