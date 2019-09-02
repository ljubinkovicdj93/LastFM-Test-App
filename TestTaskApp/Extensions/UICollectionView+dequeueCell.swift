//
//  UICollectionView+dequeueCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: ConfigurableCell>(at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable collection view cell.")
        }
        return cell
    }
    
    func register<T: ConfigurableCell>(_: T.Type) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
