//
//  Album.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

// MARK: - Album
struct Album: Decodable {
    let name: String
    let artist: String
    let mbid: String
    let url: URL
    let images: [Image]
    let listeners: String?
    let streamable: String?
    let playcount: String?
    let tracks: TracksResponse?
    let tags: TagResponse?
    let albumInformation: AlbumInformation?
    
    enum AlbumKeys: String, CodingKey {
        case name
        case artist
        case mbid
        case url
        case images = "image"
        case listeners
        case streamable
        case playcount
        case tracks
        case tags
        case albumInformation = "wiki"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artist = try container.decode(String.self, forKey: .artist)
        mbid = try container.decode(String.self, forKey: .mbid)
        
        let urlString = try container.decode(String.self, forKey: .url)
        guard let albumUrl = URL(string: urlString) else { fatalError("The url string is not valid.") }
        url = albumUrl
        
        images = try container.decode([Image].self, forKey: .images)
        listeners = try container.decodeIfPresent(String.self, forKey: .listeners)
        playcount = try container.decodeIfPresent(String.self, forKey: .playcount)
        tracks = try container.decodeIfPresent(TracksResponse.self, forKey: .tracks)
        tags = try container.decodeIfPresent(TagResponse.self, forKey: .tags)
        albumInformation = try container.decodeIfPresent(AlbumInformation.self, forKey: .albumInformation)
        streamable = try container.decodeIfPresent(String.self, forKey: .streamable)
    }
}

// MARK: - AlbumInformation
struct AlbumInformation: Codable {
    let published: Date
    let summary: String
    let content: String
    
    enum AlbumInformationKeys: String, CodingKey {
        case published
        case summary
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumInformationKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .published)
        guard let date = DateFormatter.dayMonthYearAndTime.date(from: dateString) else { fatalError("Not a valid date.") }
        published = date
        
        summary = try container.decode(String.self, forKey: .summary)
        content = try container.decode(String.self, forKey: .content)
    }
}
