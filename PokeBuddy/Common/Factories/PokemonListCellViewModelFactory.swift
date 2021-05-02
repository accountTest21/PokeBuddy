//
//  PokemonListCellViewModelFactory.swift
//  PokeBuddy
//

import UIKit

struct PokemonListCellViewModelFactory {
    let pokemon: DBPokemon?
    
    func make(with image: UIImage?) -> PokemonListCellViewModel {
        PokemonListCellViewModel(name: pokemon?.name ?? "", image: image, imageUrl: pokemon?.url)
    }
}
