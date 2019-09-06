//
//  UIColor+convenienceInit.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/6/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    private convenience init(red: Int, green: Int, blue: Int) {
        self.init(r: red,
                  g: green,
                  b: blue)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
