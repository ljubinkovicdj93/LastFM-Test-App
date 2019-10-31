//
//  ArtistDataSource.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/3/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class ArtistDataSource: CollectionArrayDataSource<Artist, ArtistCell> {
    var currentSearchText: String = ""
    private var currentPage: Int = 1
    private var isFetchingNextPage: Bool = false
    
    private var artists: [Artist] {
        if !provider.items.isEmpty {
            return provider.items[0]
        }
        return []
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let item = provider.item(at: indexPath) {
            let cell: ArtistCell = collectionView.dequeueCell(at: indexPath)
            cell.configure(item)
            return cell
        }
        
        if artists.isEmpty {
            let nothingFoundCell: NothingFoundCell = collectionView.dequeueCell(at: indexPath)
            #warning("TODO: LOCALIZE THIS")
            nothingFoundCell.configure("Nothing found.")
            
            return nothingFoundCell
        }
            
        if isLoadingIndexPath(indexPath) {
            let loadingCell: ArtistCell = collectionView.dequeueCell(at: indexPath)
            loadingCell.configure(.none)
            return loadingCell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let needsFetch = indexPaths.contains { $0.row >= provider.items[0].count }
        if needsFetch {
            fetchNextPage()
        }
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= artists.count
    }
    
    private func fetchNextPage() {
        guard !isFetchingNextPage else { return }
        
        currentPage += 1
        fetchArtists(currentSearchText)
    }
    
    // MARK: - Helpers
    private func refreshList(with artists: [Artist] = []) {
        self.removeItems()
        if !artists.isEmpty {
            self.provider.addItems(values: artists)
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
    
    func fetchArtists(_ artistName: String?) {
        guard
            let txt = artistName,
            !txt.isEmpty
            else { return }
        
        currentSearchText = txt
        
        Router.ArtistsRoute.searchAll(txt) { [weak self] (result: Result<ArtistSearchResults, Error>) in
            guard let self = self else { return }
            self.handleResponse(result)
        }
    }
}
