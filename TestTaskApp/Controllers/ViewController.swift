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

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var artistDataSource: ArtistDataSource?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        
        searchTextField.delegate = self
        // Gets the value of the text field as we type.
        searchTextField.addTarget(self,
                                  action: #selector(textFieldDidChange(_:)),
                                  for: UIControl.Event.editingChanged)
        
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
}

extension ViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField : UITextField) {
        guard let txt = textField.text else { return }

        print("textFieldDidChange:", txt)
        
        if txt.isEmpty {
            artistDataSource?.removeItems()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let txt = textField.text, !txt.isEmpty else { return false }
        
        artistDataSource?.removeItems()
        
        print("textField.text: \(textField.text)")
        AF.request(Router.ArtistsRoute.searchRoute(artistName: textField.text!))
            .validate()
            .responseDecodable { [weak self] (response: DataResponse<ArtistSearchResults>) in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let albumResults):
                    let artistList = albumResults.results.artistmatches.artist
                    self.artistDataSource?.provider.addItems(values: artistList)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    debugPrint(response)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
        }
        return true
    }
}
