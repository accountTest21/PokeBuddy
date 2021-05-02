//
//  PokemonFactory.swift
//  PokeBuddy
//

import Foundation

struct DBPokemonFactory {
    let pokemon: (pokemonItem: PokemonItem, pokemonDetail: PokeBuddyService.FetchPokemonDetailResponse)
//TODO: refactor and handle some erro
    func make() -> Pokemon {
        let pokemonDetail = try? pokemon.pokemonDetail.get()
        let stringUrl = try? pokemon.pokemonDetail.get().sprites.front_default
        let number = pokemonNumberGetter() ?? 0
        
        var statsDict = [String:Int]()
        var typeArray = [String]()
        
        pokemonDetail?.stats.forEach({ stat in
            statsDict[stat.stat.name] = stat.base_stat
        })
        
        pokemonDetail?.types.forEach({ type in
            typeArray.append(type.type.name)
        })
        
        
        return Pokemon(number: number,
                          name: pokemon.pokemonItem.name,
                          imageUrl: stringUrl ?? "",
                          stats: statsDict,
                          types: typeArray)
    }
    
    private func pokemonNumberGetter() -> Int? {
        guard let stringNumber = pokemon.pokemonItem.url.split(separator: "/").last else { return nil }
        
        return Int(stringNumber)
    }
}
