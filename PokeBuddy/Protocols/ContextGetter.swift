//
//  ContextGetter.swift
//  PokeBuddy
//

import UIKit
import CoreData

protocol ContextGetter {
    var context: NSManagedObjectContext? { get }
}

extension ContextGetter {
    var context: NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }
}
