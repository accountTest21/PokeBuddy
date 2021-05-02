//
//  ViewController.swift
//  PokeBuddy
//

import UIKit

class PokemonListViewController: UIViewController {
    private let tableView = UITableView()
    private var viewModel: PokemonListViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "PokeBuddy"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        viewModel?.loadItems()
    }
    
    func set(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
    }
}

//MARK: - Private Methods
extension PokemonListViewController {
    private func setup() {
        bind()
        setupConstraints()
        setupTableView()
        setBackgroundColor()
    }
    
    private func bind() {
        viewModel?.datasourceChanged = { [weak self] _ in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.onNetworkError = { [weak self] in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let factory = AlertFactory { [weak self] in
                    self?.viewModel?.loadItems()
                }
                
                let alert = factory.makeNetworkAlert()
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setBackgroundColor() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = .black
            } else {
                view.backgroundColor = .white
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(PokemonListCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

//MARK: - UITableViewDataSource
extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.datasource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PokemonListCell()
        
        if let cellViewModel = viewModel?.getCellViewModel(for: indexPath) {
            cell.configure(viewModel: cellViewModel)
        }
        
        if indexPath.row == (viewModel?.datasource.count ?? 0) - 1 {
            viewModel?.loadItems()
        }
        
        return cell
    }

}

//MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PokemonDetailViewController()
        // add set view model
        let pokemon = viewModel?.datasource[indexPath.row]
        let viewModel = pokemon.map {
            PokemonDetailViewModel(pokemonImageUrl: $0.url ?? "",
                                   pokemonName: $0.name ?? "",
                                   pokemonStats: $0.stats ?? [:],
                                   pokemonTypes: $0.types ?? [String]())
        }
        
        viewController.set(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
