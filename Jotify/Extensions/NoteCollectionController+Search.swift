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
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.isActive = false
        searchController.searchBar.scopeButtonTitles = ["Content", "Date"]
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            filteredNotes = (noteCollection?.FBNotes.filter { (note: FBNote) -> Bool in
                note.content.lowercased().contains(searchText.lowercased())
            })!
            
            collectionView.reloadData()
            
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            filteredNotes = (noteCollection?.FBNotes.filter { (note: FBNote) -> Bool in
                note.timestamp.getDate().lowercased().contains(searchText.lowercased())
            })!
            
            collectionView.reloadData()
        }
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
