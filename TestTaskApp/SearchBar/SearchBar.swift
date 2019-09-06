//
//  SearchBar.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/6/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit


class SearchBar: UISearchBar {
    static let MIN_CHARS_TO_SEARCH: Int = 2
    
    /// Throttle engine
    private var throttler: Throttler? = nil
    
    /// Throttling interval
    var throttlingInterval: Double? = 0 {
        didSet {
            guard let interval = throttlingInterval else {
                self.throttler = nil
                return
            }
            self.throttler = Throttler(seconds: Int(interval))
        }
    }
    
    /// Event received when cancel is pressed
    var onCancel: (() -> (Void))? = nil
    
    /// Event received when a change into the search box is occurred
    var onSearch: ((String) -> (Void))? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let throttler = self.throttler else {
            self.onSearch?(searchText)
            return
        }
        throttler.throttle {
            DispatchQueue.main.async {
                self.onSearch?(self.text ?? "")
            }
        }
    }
}
