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
        return UIStatusBarStyle.default
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
        // Receive events for search
        searchBar.onSearch = { [unowned self] text in
            guard !text.isEmpty else { return }
            self.reloadData(text)
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
    
    private func handleResponse(_ result: Result<ArtistSearchResults, Error>) {
        switch result {
        case .success(let artistResults):
            guard !artistResults.results.artistmatches.artist.isEmpty else {
                self.refreshList()
                return
            }
            
            let artistList = artistResults.results.artistmatches.artist
            
            self.refreshList(with: artistList)
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    private func reloadData(_ text: String?) {
        guard
            let txt = text,
            !txt.isEmpty
            else { return }
        
        Router.ArtistsRoute.searchAll(txt) { [weak self] (result: Result<ArtistSearchResults, Error>) in
            guard let self = self else { return }
            self.handleResponse(result)
        }
    }
}
