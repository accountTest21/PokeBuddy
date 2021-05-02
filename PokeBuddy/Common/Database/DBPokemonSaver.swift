//
//  DBPokemonSaver.swift
//  PokeBuddy
//

import UIKit
import Foundation
import CoreData

class DBPokemonSaver: ContextGetter {
    func save(items: [(PokemonItem, PokeBuddyService.FetchPokemonDetailResponse)], completion: @escaping () -> ()) {
        let pokemonArray = items.map { (item) -> Pokemon in
            DBPokemonFactory(pokemon: item).make()
        }
        
        let group = DispatchGroup()
        
        pokemonArray.forEach({ pokemon in
            group.enter()
            
            save(item: pokemon, completed: {
                group.leave()
            })
        })
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func save(item: Pokemon, completed: @escaping () -> ()) {
        DispatchQueue.main.async {
            guard let managedContext = self.context else { return }
            
            let entity =
                NSEntityDescription.entity(forEntityName: "DBPokemon",
                                           in: managedContext)!
            
            let pokemon = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
            
            // 3
            pokemon.setValue(item.name, forKeyPath: "name")
            pokemon.setValue(item.imageUrl, forKey: "url")
            pokemon.setValue(item.number, forKey: "number")
            pokemon.setValue(item.stats, forKey: "stats")
            pokemon.setValue(item.types, forKey: "types")
            
            // 4
            do {
                try managedContext.save()
                //self.pokemons.append(pokemon)
                completed()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}

