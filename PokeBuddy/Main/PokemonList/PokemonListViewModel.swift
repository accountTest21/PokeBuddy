//
//  PokemonListViewModel.swift
//  PokeBuddy
//

import UIKit


class PokemonListViewModel {
    
    private var _datasource: [DBPokemon] = [DBPokemon]()
    
    private let saver = DBPokemonSaver()
    private let fetcher = DBPokemonFetcher()
    private let service = PokeBuddyService()
    private let cache = NSCache<NSString, UIImage>()
    private var maxPokemonsCount: Int = 1000
    private var limit: Int = 20
    private var offset: Int {
        datasource.count
    }
    
    var datasourceChanged: (([DBPokemon]) -> ())?
    var onNetworkError: (() -> ())?
    
    public var datasource: [DBPokemon] {
        get {
            return _datasource
        }
        set {
            _datasource = newValue
            var datasourceToSort = _datasource
        
            (datasourceToSort).sort(by: { (item1, item2) -> Bool in
                item1.number < item2.number
            })
            
            _datasource = (datasourceToSort)
            
            datasourceChanged?(_datasource)
        }
    }
    
    func set(datasource: [DBPokemon]) {
        self.datasource.append(contentsOf: datasource)
    }
    
    func loadItems() {
        if datasource.count != maxPokemonsCount {
            let pokemon = fetchPokemon()
            
            if pokemon.count == 0 {
                fetchNewItems()
                
            } else {
                datasource.append(contentsOf: pokemon)
            }
        }
    }
    
    func fetchNewItems() {
        fetchPokemonService { [weak self] (response) in
            switch response {
            case .success(let res):
                self?.maxPokemonSetter(count: res.count)
                self?.fetchPokemonDetailService(from: res.results) { (res) in
                    self?.saver.save(items: res, completion: {
                        self?.loadItems()
                    })
                }
                
            case .failure(_):
                self?.onNetworkError?()
                return
            }
        }
    }
    
    private func maxPokemonSetter(count: Int) {
        if maxPokemonsCount != count {
            maxPokemonsCount = count
        }
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> PokemonListCellViewModel {
        let pokemon = datasource[indexPath.row]
        
        let factory = PokemonListCellViewModelFactory(pokemon: pokemon)
        
        return factory.make(with: getImage(from: pokemon.url))
    }
}

//MARK: - Private methods
extension PokemonListViewModel {
    private func fetchPokemon() -> [DBPokemon] {
        fetcher.fetch(limit: limit, offset: offset)
    }
    
    private func fetchPokemonService(completion: @escaping (PokeBuddyService.FetchPokemonResponse) -> Void) {
        try? service.fetchPokemon(offset: offset, limit: limit, completion: completion)
    }
    
    private func fetchPokemonDetailService(from items: [PokemonItem], completion: @escaping ([(PokemonItem, PokeBuddyService.FetchPokemonDetailResponse)]) -> Void) {
        let group = DispatchGroup()
        
        var responses = [(PokemonItem, PokeBuddyService.FetchPokemonDetailResponse)]()
        
        items.forEach { pokemon in
            group.enter()
            
            try? self.service.fetchDetail(for: pokemon) { (response) in
                responses.append((pokemon, response))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(responses)
        }
    }
    
    private func getImage(from url: String?) -> UIImage? {
        guard let stringUrl = url, let url = URL(string: stringUrl) else { return nil }
        
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            return image
            
        } else {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    cache.setObject(image, forKey: url.absoluteString as NSString)
                    return image
                }
            }
        }
        return nil
    }
}
