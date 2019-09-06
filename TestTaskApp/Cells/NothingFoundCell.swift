//
//  NothingFoundCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/5/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

class NothingFoundCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(_ item: String?) {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 2.0
        
        titleLabel.text = item!
    }
}
