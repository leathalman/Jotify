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
        // Inline placement keeps the search bar as a pill next to the title
        // instead of a separate stacked row. The nav bar's height stays
        // constant across push/pop, so UIKit doesn't have to synchronously
        // collapse a row when transitioning out (gear → settings, note →
        // detail) — which was the visible lag before the push animation.
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .inline
        }
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        // Unified search — match either the note body or its displayed date.
        let query = searchText.lowercased()
        let errorNote: [FBNote] = [FBNote(content: "", timestamp: 0, id: "", color: "blue")]

        filteredNotes = (noteCollection?.FBNotes.filter { note in
            note.content.lowercased().contains(query) ||
            note.timestamp.getDate().lowercased().contains(query)
        }) ?? errorNote

        collectionView.reloadData()
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
