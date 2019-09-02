//
//  AlbumCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var albumImageView: UIImageView!
    
    func configure(_ item: Album) {
        nameLabel.text = item.name
        artistLabel.text = item.artist
        albumImageView.image = UIImage(named: item.images.last!.text)
    }
}
