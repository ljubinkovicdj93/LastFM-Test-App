//
//  Track.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

// MARK: - Track
struct Track: Codable {
    let name: String
    let url: String
    let duration: String
    let attribute: Attribute
    let streamable: Streamable
    let artist: Artist
    
    enum CodingKeys: String, CodingKey {
        case name, url, duration
        case attribute = "@attr"
        case streamable, artist
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let rank: String
}

// MARK: - Streamable
struct Streamable: Codable {
    let text, fulltrack: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack
    }
}
