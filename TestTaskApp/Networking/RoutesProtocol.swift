//
//  RoutesProtocol.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/30/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation
import Alamofire

typealias QueryItems = [URLQueryItem]

enum URLError: Error {
    case invalidURL
}

protocol Routable {
    var route: String { get set }
    var queryItems: QueryItems! { get set }
    init()
}

// If we have a route that conforms to either Readable, Creatable, Updatable, or Deletable,
// we need to declare a route variable and implement an init method.
protocol Creatable: Routable {}
extension Creatable where Self: Routable {
    
    /// Method that allows route to create an object
    ///
    /// - Parameter parameters: Dictionary of objects that will be used to create object
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.Album.create(queryItems: ["name": "My First Album",
    ///                                 "artist": "Djordje Ljubinkovic"])
    ///````
    static func create(queryItems: QueryItems = []) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)"
        return RequestConverter(method: .post, route: route, queryItems: queryItems)
    }
}

protocol Readable: Routable {}
extension Readable where Self: Routable {
    /// Method that allows route to return an object
    ///
    /// - Parameter params: Parameters of the object that is being returned
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.Album.get(params: "1", queryItems: ["method": "album.getinfo"])
    ///````
    static func get(params: String = "", queryItems: QueryItems = []) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)" + (params.isEmpty ? "" : "/\(params)")
        return RequestConverter(method: .get, route: route, queryItems: queryItems)
    }
}

protocol Updatable: Routable {}
extension Updatable where Self: Routable {
    /// Method that allows route to update an object
    ///
    /// - Parameter parameters: Dictionary of objects that will be used to create object
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.Album.update(params: "1", queryItems: ["name": "My Second Album"])
    ///````
    static func update(params: String, queryItems: QueryItems = []) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)/\(params)"
        return RequestConverter(method: .put, route: route, queryItems: queryItems)
    }
}

protocol Deletable: Routable {}
extension Deletable where Self: Routable {
    /// Method that allows route to delete an object
    ///
    /// - Parameter params: Parameters of the object that is being deleted
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// Router.Album.delete(params: "1")
    ///````
    static func delete(params: String, queryItems: QueryItems = []) -> RequestConverter {
        let temp = Self.init()
        let route = "\(temp.route)/\(params)"
        return RequestConverter(method: .delete, route: route, queryItems: queryItems)
    }
}

protocol RequestConverterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get set }
    var route: String { get set }
    var queryItems: QueryItems { get set }
}

/// Converter object that will allow us to play nicely with Alamofire
struct RequestConverter: RequestConverterProtocol {
    
    var method: HTTPMethod
    var route: String
    var queryItems: QueryItems = []
    
    /// Create a RequestConverter object
    ///
    /// - Parameters:
    ///   - method: Method to perform on router. Example: `.get`, `.post`, etc.
    ///   - route: Route endpoint on url.
    ///   - parameters: Optional dictionary to pass in objects. Used for `.post` and `.put`
    init(method: HTTPMethod, route: String, queryItems: QueryItems = []) {
        self.method = method
        self.route = route
        self.queryItems = queryItems
    }
    
    // MARK: - URLRequestConvertible method
    // When we give Alamofire.request() an enum like TodoRouter.get(1) then it calls asURLRequest() to get the request to send.
    func asURLRequest() throws -> URLRequest {
        do {
            var urlComponents = Router.basePathComponents
            
            // Additional query items to add before we send out our request.
            urlComponents.queryItems?.append(contentsOf: self.queryItems)
            
            guard let url = urlComponents.url else { throw URLError.invalidURL }
            var urlRequest = URLRequest(url: url.appendingPathComponent(route))
            
            urlRequest.httpMethod = self.method.rawValue
            
            return try URLEncoding.default.encode(urlRequest, with: nil)
        } catch {
            print("asUrlRequestError: \(error.localizedDescription)")
            throw error
        }
    }
}
