//
//  SearchBar.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/6/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let reloadData = #selector(SearchBar.reloadData(_:))
}

class SearchBar: UISearchBar {
    /// Event received when cancel is pressed
    var onCancel: (() -> (Void))? = nil
    
    /// Event received when a change into the search box is occurred
    var onSearch: ((String) -> (Void))? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.enablesReturnKeyAutomatically = true
        self.delegate = self
    }
}

// MARK: - Events for UISearchBarDelegate
extension SearchBar: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.onCancel?()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.onSearch?(self.text ?? "")
        self.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: .reloadData,
                                               object: nil)
        
        // We will receive a new value to search for an interval >= 0.5 seconds.
        self.perform(.reloadData,
                     with: searchText,
                     afterDelay: 0.5)
    }
    
    @objc fileprivate func reloadData(_ text: String?) {
        self.onSearch?(self.text ?? "")
    }
}
