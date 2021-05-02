//
//  PokeBuddyService.swift
//  PokeBuddy
//

import UIKit

protocol PokemonService {
    associatedtype T
    associatedtype N
    
    func fetchPokemon(offset: Int, limit: Int, completion: @escaping ((T) -> Void)) throws
    func fetchDetail(for pokemon: PokemonItem, completion: @escaping (N) -> Void) throws
}

struct PokeBuddyService: PokemonService {
    typealias FetchPokemonResponse = Result<PokemonServiceResponse, PokeBuddyServiceError>
    typealias FetchPokemonDetailResponse = Result<PokemonDetailResponse, PokeBuddyServiceError>
    
    enum PokeBuddyServiceError: Error {
        case invalidUrl
        case networkError(String)
        case decodingError(String)
    }

    func fetchPokemon(offset: Int, limit: Int, completion: @escaping ((FetchPokemonResponse) -> Void)) throws {
        guard
            let url = Endpoint.getPokemon(limit: limit, offeset: offset).url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.networkError(error?.localizedDescription ?? "")))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PokemonServiceResponse.self, from: data)
                completion(.success(response))
            
            } catch(let error) {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }.resume()
    }
    
    func fetchDetail(for pokemon: PokemonItem, completion: @escaping (FetchPokemonDetailResponse) -> Void) throws {
        guard
            let url = URL(string: pokemon.url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.networkError(error?.localizedDescription ?? "")))
                return
            }
            
            do {
                let item = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                completion(.success(item))
            
            } catch(let error) {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }.resume()
    }
}
