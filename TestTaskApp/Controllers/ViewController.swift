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
    
    private var albumList: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
        
        #warning("TODO: Remove, use to test only.")
        AF.request(Router.AlbumsRoute.searchRoute(albumName: "Believe")).responseDecodable { [weak self] (response: DataResponse<AlbumSearchResults>) in
            guard let self = self else { return }

            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            switch response.result {
            case .success(let albumResults):
                print("Validation Successful")
                
                self.albumList = albumResults.results.albummatches.album
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                debugPrint(response)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
//        AF.request(Router.AlbumsRoute.getInfoRoute(artistName: "Cher", albumName: "Believe")).responseDecodable { (response: DataResponse<AlbumResult>) in
//
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            switch response.result {
//            case .success(let albumResult):
//                print("Validation Successful")
//                debugPrint(response)
//
//                albumList = albumResult.album
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            }
//        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.album = albumList[indexPath.row]
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(albumList[indexPath.item])
    }
}
