//
//  DBPokemonFetcher.swift
//  PokeBuddy
//

import Foundation
import CoreData

class DBPokemonFetcher: ContextGetter {
    private var pokemons: [NSManagedObject] = []
    
    func fetch(limit: Int, offset: Int) -> [DBPokemon] {
        guard let managedContext = context else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBPokemon")
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        
        do {
            pokemons = try managedContext.fetch(fetchRequest)
            
            let pkm = pokemons as? [DBPokemon]
            return pkm ?? []
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
}
