//
//  Router.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Alamofire

/// Protocol that allows us to implement a base URL for our application
protocol URLRouter {
    static var basePathComponents: URLComponents { get }
}

struct Router: URLRouter {
    static var basePathComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        components.host = Environment().configuration(PlistKey.serverUrlDomainName)
        components.path = "/2.0/"
        
        // Query items that go with all requests.
        components.queryItems = [
            URLQueryItem(name: "api_key",
                         value: Environment().configuration(PlistKey.apiKey)),
            URLQueryItem(name: "format",
                         value: "json")
        ]
        
        return components
    }
    
    struct AlbumsRoute: Readable {
        var route: String = ""
        var queryItems: QueryItems!
    }
    
    struct ArtistsRoute: Readable {
        var route: String = ""
        var queryItems: QueryItems!
    }
}

extension Router.ArtistsRoute {
    // http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=cher&api_key=e1116ff78e72bee82a5e4e0db782ea05&format=json
    static func searchRoute(artistName: String, pageNumber: Int = 1) -> RequestConverter {
        let queryItems: QueryItems = [
            URLQueryItem(name: "method", value: "artist.search"),
            URLQueryItem(name: "artist", value: artistName),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
        
        return Router.AlbumsRoute.get(queryItems: queryItems)
    }
}

extension Router.AlbumsRoute {
//    /2.0/?method=album.search&album=believe&api_key=YOUR_API_KEY
    static func searchRoute(albumName: String) -> RequestConverter {
        let queryItems: QueryItems = [
            URLQueryItem(name: "method", value: "album.search"),
            URLQueryItem(name: "album", value: albumName)
        ]
        
        return Router.AlbumsRoute.get(queryItems: queryItems)
    }
    
// /2.0/?method=album.getinfo&api_key=YOUR_API_KEY&artist=Cher&album=Believe
    static func getInfoRoute(artistName: String, albumName: String) -> RequestConverter {
        let queryItems: QueryItems = [
            URLQueryItem(name: "method", value: "album.getinfo"),
            URLQueryItem(name: "artist", value: artistName),
            URLQueryItem(name: "album", value: albumName)
        ]
        
        return Router.AlbumsRoute.get(queryItems: queryItems)
    }
}
