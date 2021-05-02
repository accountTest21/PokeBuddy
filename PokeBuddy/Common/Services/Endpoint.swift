//
//  Endpoint.swift
//  PokeBuddy
//

import Foundation

enum API: String {
    static var baseURL: String = "pokeapi.co"
    
    case fetchPokemons = "/api/v2/pokemon/"
    
    var stringURL: String {
        API.baseURL + self.rawValue
    }
}

struct Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryParameters: [ URLQueryItem]
    
    init(scheme: String, host: String, path: String, queryParameters: [URLQueryItem]) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryParameters = queryParameters
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters
        }
        
        return components.url
    }
    
    var stringUrl: String? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters
        }
        
        return components.string
    }
}

extension Endpoint {
    static func getPokemon(limit: Int, offeset: Int) -> Endpoint {
        Endpoint(scheme: "https",
                 host: API.baseURL,
                 path: API.fetchPokemons.rawValue,
                 queryParameters: [
                    URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "offset", value: "\(offeset)"),
        ])
    }
}
