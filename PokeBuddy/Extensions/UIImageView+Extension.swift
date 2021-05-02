//
//  UIImageView+Extension.swift
//  PokeBuddy
//

import UIKit
import CoreData

extension UIImageView: ContextGetter {
    func load(url: URL) {
        DispatchQueue.main.async {
            guard let managedContext = self.context else { return }
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBPokemonImage")
            fetchRequest.predicate = NSPredicate(format: "url == %@", url.absoluteString)
            
            guard
                let object = try? managedContext.fetch(fetchRequest).first as? DBPokemonImage else {
               
                
                if let entity = NSEntityDescription.entity(forEntityName: "DBPokemonImage", in: managedContext) {
                    let pokemonImage = NSManagedObject(entity: entity, insertInto: managedContext)
                        pokemonImage.setValue(url.absoluteString, forKeyPath: "url")
                    
                    if let data = try? Data(contentsOf: url) {
                        pokemonImage.setValue(try? Data(contentsOf: url), forKey: "image")
                        self.image = UIImage(data: data)
                    }
                    
                    try? managedContext.save()
                }
                return
            }
            
            
            if let data = object.image {
                self.image = UIImage(data: data)
                return
            
            } else {
                if let data = try? Data(contentsOf: url) {
                    object.image = data
                    
                    try? managedContext.save()
                    
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
