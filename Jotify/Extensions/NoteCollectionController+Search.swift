//
//  NoteCollectionController+Search.swift
//  Jotify
//
//  Created by Harrison Leath on 5/3/21.
//

import UIKit

extension NoteCollectionController: UISearchBarDelegate {

    func setupSearchBar() {
        // Plain UISearchBar instead of UISearchController. UISearchController
        // paid a noticeable first-tap cost on cold launch while UIKit built
        // out its private results/dimming/animator hierarchy. A bare search
        // bar has none of that — `becomeFirstResponder` is cheap from cold.
        searchBar.placeholder = "Search Notes"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.returnKeyType = .search
        searchBar.delegate = self
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

    var isFiltering: Bool {
        return !isSearchBarEmpty
    }

    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }

    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        filterContentForSearchText("")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
