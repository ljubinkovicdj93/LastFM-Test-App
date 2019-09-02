//
//  ConfigurableCell.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

public protocol ConfigurableCell: ReusableCell {
    associatedtype T
    
    func configure(_ item: T)
}
