//
//  Tag.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

// MARK: - TagResponse
struct TagResponse: Codable {
    let tag: [Tag]
}

// MARK: - Tag
struct Tag: Codable {
    let name: String
    let url: String
}
