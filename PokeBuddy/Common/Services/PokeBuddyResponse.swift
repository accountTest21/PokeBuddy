//
//  PokeBuddyResponse.swift
//  PokeBuddy
//

import Foundation

struct PokemonServiceResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}

struct PokemonItem: Codable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Codable {
    let sprites: Sprite
    let stats: [Stat]
    let types: [PokemonType]
}

struct PokemonType: Codable {
    let type: PokemonTypeDetail
}

struct PokemonTypeDetail: Codable {
    let name: String
}

struct Sprite: Codable {
    let front_default: String
}

struct Stat: Codable {
    let base_stat: Int
    let effort: Int
    let stat: StatDetail
}

struct StatDetail: Codable {
    let name: String
}
