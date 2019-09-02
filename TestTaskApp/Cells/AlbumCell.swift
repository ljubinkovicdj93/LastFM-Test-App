//
//  AlbumCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var albumImageView: UIImageView!
    
    var album: Album? {
        didSet {
            if let album = album {
                nameLabel.text = album.name
                artistLabel.text = album.artist
                albumImageView.image = UIImage(named: album.images.last!.text)
            }
        }
    }
}
