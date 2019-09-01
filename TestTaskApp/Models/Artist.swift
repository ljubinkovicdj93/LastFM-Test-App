//
//  Artist.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

enum ImageSize {
    case small
    case medium
    case large
    case extraLarge
    case mega
    case unknown
}

// MARK: - Artist
struct Artist: Decodable {
    let name: String
    let mbid: String
    let url: String
    
    // MARK: - Optional properties
    // These might be omitted from some responses.
    let listeners: String?
    let streamable: String?
    let image: [Image]?
}

// MARK: - Image
struct Image: Decodable {
    let text: String
    let size: ImageSize
    
    enum ImageKeys: String, CodingKey {
        case text = "#text"
        case size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageKeys.self)
        
        text = try container.decode(String.self, forKey: .text)
        let sizeString = try container.decode(String.self, forKey: .size)
        switch sizeString {
            case "small": size = .small
            case "medium": size = .medium
            case "large": size = .large
            case "extralarge": size = .extraLarge
            case "mega": size = .mega
            default: size = .unknown
        }
    }
    
    private func determineImageSize(_ sizeString: String) -> ImageSize {
        switch sizeString {
        case "small": return .small
        case "medium": return .medium
        case "large": return .large
        case "extralarge": return .extraLarge
        case "mega": return .mega
        default: return .unknown
        }
    }
}

