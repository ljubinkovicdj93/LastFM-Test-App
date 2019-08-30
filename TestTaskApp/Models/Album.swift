//
//  Album.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

// MARK: - Album
struct Album: Codable {
    let name: String
    let playcount: Int
    let mbid: String
    let url: String
    let artist: Artist
    let image: [Image]
    
    // Might not contain these
    let tracks: [Track]
    let tags: [Tag]
    let albumInformation: AlbumInformation
    let listeners: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case playcount
        case mbid
        case url
        case artist
        case image
        case tracks
        case tags
        case albumInformation = "wiki"
        case listeners
    }
}
