//
//  NothingFoundCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/5/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class NothingFoundCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(_ item: String?) {
        containerView.backgroundColor = UIColor(hex: 0xC9C9CE)
        
        titleLabel.textColor = .white
        titleLabel.text = item!
    }
}
