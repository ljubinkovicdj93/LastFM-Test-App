//
//  ArtistCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/3/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class ArtistCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var listenersCountLabel: UILabel!
    @IBOutlet private weak var artistImageView: UIImageView!

    func configure(_ item: Artist) {
        nameLabel.text = item.name
        listenersCountLabel.text = item.listeners
        if let mediumImgTxt = item.images?.filter({ $0.size == .medium }).first?.text,
            let mediumImgUrl = URL(string: mediumImgTxt) {
            URLSession.shared.dataTask(with: mediumImgUrl) { (data, response, error) in
                if error != nil { print("Failed fetching the image error."); return }
                
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    else { print("Not a proper HTTPURLResponse or statusCode"); return }
                
                DispatchQueue.main.async {
                    self.artistImageView.image = UIImage(data: data!)
                }
            }.resume()
        }
    }
}
