//
//  ViewController.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var artistDataSource: ArtistDataSource?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSearchBar()
    }
    
    // MARK: - Setup
    private func setupViews() {
        collectionView.register(NothingFoundCell.self)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        
        artistDataSource = setupDataSource(items: [])
        artistDataSource?.removeItems() // this ensures we don't get a blank screen on the initial load, but instead a cell.
    }
    
    private func setupDataSource(items: [Artist]) -> ArtistDataSource {
        let dataSource = ArtistDataSource(collectionView: self.collectionView,
                                          array: [items])
        
        dataSource.collectionItemSelectionHandler = { [weak self] indexPath in
            //            guard let self = self else { return }
            
            print(dataSource.item(at: indexPath) ?? "NO ITEM FOUND")
            //            self.performSegue(withIdentifier: "someSegue", sender: nil)
        }
        
        return dataSource
    }
    
    private func setupSearchBar() {
        // Set the throttle interval. We will receive a new
        // value to search for an interval >= 0.5 seconds.
        searchBar.throttlingInterval = 0.5
        
        // Receive events for search
        searchBar.onSearch = { text in
            // user tapped the 'X' button
            if text.count > SearchBar.MIN_CHARS_TO_SEARCH {
                AF.request(Router.ArtistsRoute.searchRoute(artistName: text))
                    .validate()
                    .responseDecodable { [weak self] (response: DataResponse<ArtistSearchResults>) in
                        guard let self = self else { return }
                        
                        switch response.result {
                        case .success(let artistResults):
                            guard !artistResults.results.artistmatches.artist.isEmpty else {
                                self.refreshList()
                                return
                            }
                            
                            let artistList = artistResults.results.artistmatches.artist
                            
                            self.refreshList(with: artistList)
                            
                            debugPrint(response)
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func refreshList(with artists: [Artist] = []) {
        self.artistDataSource?.removeItems()
        if !artists.isEmpty {
            self.artistDataSource?.provider.addItems(values: artists)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
