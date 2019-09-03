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

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var albumDataSource: ArtistDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.register(AlbumCell.self)
        collectionView.register(ArtistCell.self)
        
        #warning("TODO: Remove, use to test only.")
//        AF.request(Router.AlbumsRoute.searchRoute(albumName: "Believe"))
//            .validate()
//            .responseDecodable { [weak self] (response: DataResponse<AlbumSearchResults>) in
//            guard let self = self else { return }
//
//            switch response.result {
//            case .success(let albumResults):
//                let albumList = albumResults.results.albummatches.album
//                self.albumDataSource = self.setupDataSource(items: albumList)
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//
//                debugPrint(response)
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            }
//        }
        
        AF.request(Router.ArtistsRoute.searchRoute(artistName: "Freddie"))
            .validate()
            .responseDecodable { [weak self] (response: DataResponse<ArtistSearchResults>) in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let albumResults):
                    let albumList = albumResults.results.artistmatches.artist
                    self.albumDataSource = self.setupDataSource(items: albumList)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    debugPrint(response)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
        }
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
}
