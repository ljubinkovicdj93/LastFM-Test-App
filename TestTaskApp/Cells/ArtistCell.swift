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
    @IBOutlet private weak var imageCoverView: UIView!

    func configure(_ item: Artist?) {
        guard let item = item else { return }
        nameLabel.text = item.name
        #warning("TODO: Localize these.")
        listenersCountLabel.text = "Listeners #: \(item.listeners ?? "0")"
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = ParallaxLayoutConstants.Cell.featuredHeight
        let standardHeight = ParallaxLayoutConstants.Cell.standardHeight
        
        /* Represents the progress of the cell transitioning to be the featured cell. */
        let delta = 1.0 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.20
        let maxAlpha: CGFloat = 0.80
        
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        /* Don't want it to be less than half its full size. */
        let scale = max(delta, 0.5)
        nameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        listenersCountLabel.alpha = delta
    }
}
