//
//  Artist.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

// MARK: - Artist
struct Artist: Codable {
    let name, listeners, mbid: String
    let url: String
    let streamable: String
    let image: [Image]
}

// MARK: - Image
struct Image: Codable {
    let text: String
    let size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

