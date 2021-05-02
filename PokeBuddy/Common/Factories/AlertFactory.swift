//
//  AlertFactory.swift
//  PokeBuddy
//

import UIKit

struct AlertFactory {
    var action: (() -> Void)?
    
    func makeNetworkAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "An error as occurred", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            action?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        return alert
    }
}
