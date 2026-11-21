//
//  NoteCollectionController+Search.swift
//  Jotify
//
//  Created by Harrison Leath on 5/3/21.
//

import UIKit

extension NoteCollectionController: UISearchResultsUpdating, UISearchControllerDelegate {

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        definesPresentationContext = true
    }

    /// Notes whose text or displayed date contains the query.
    func matches(for searchText: String) -> [FBNote] {
        let query = searchText.lowercased()
        return (noteCollection?.FBNotes ?? []).filter { note in
            note.content.lowercased().contains(query) ||
            note.timestamp.getDate().lowercased().contains(query) ||
            SavedNoteCell.shortDate(note.timestamp).lowercased().contains(query)
        }
    }

    var searchText: String {
        searchController.searchBar.text ?? ""
    }

    var isFiltering: Bool {
        !searchText.isEmpty
    }

    func updateSearchResults(for searchController: UISearchController) {
        filteredNotes = matches(for: searchText)
        applySnapshot(animated: false)
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        setSelecting(false)
    }
}
