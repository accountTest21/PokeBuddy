//
//  PokemonDetailViewController.swift
//  PokeBuddy
//

import UIKit

struct PokemonDetailViewModel {
    let pokemonImageUrl: String
    let pokemonName: String
    let pokemonStats: [String:Int]
    let pokemonTypes: [String]
}

class PokemonDetailViewController: UIViewController {
    private var viewModel: PokemonDetailViewModel?
    
    private let pokemonImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.backgroundColor = .clear
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let pokemonTypeLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        lbl.textAlignment = .left
        lbl.text = "Types"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let pokemonStatsLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        lbl.textAlignment = .left
        lbl.text = "Stats"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let typesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonImageView.layer.cornerRadius = pokemonImageView.frame.height / 2
    }
    
    func set(viewModel: PokemonDetailViewModel?) {
        self.viewModel = viewModel
    }
}

//MARK: - Private methods

extension PokemonDetailViewController {
    private func setup() {
        setBackgroundColor()
        setupConstraints()
        setupUI()
    }

    private func setupConstraints() {
        setupScrollView()
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonTypeLabel)
        contentView.addSubview(pokemonStatsLabel)
        
        pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        pokemonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        pokemonImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        pokemonImageView.widthAnchor.constraint(equalTo: pokemonImageView.heightAnchor, multiplier: 1).isActive = true
        pokemonTypeLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20).isActive = true
        pokemonTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        
        typesStack.translatesAutoresizingMaskIntoConstraints = false
        typesStack.axis = .vertical
        contentView.addSubview(typesStack)
        
        contentView.addSubview(statsStack)
        
        pokemonStatsLabel.topAnchor.constraint(equalTo: typesStack.bottomAnchor, constant: 20).isActive = true
        pokemonStatsLabel.leadingAnchor.constraint(equalTo: pokemonTypeLabel.leadingAnchor, constant: 0).isActive = true
        
        statsStack.topAnchor.constraint(equalTo: pokemonStatsLabel.bottomAnchor, constant: 10).isActive = true
        statsStack.leadingAnchor.constraint(equalTo: pokemonTypeLabel.leadingAnchor, constant: 0).isActive = true
        statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
        statsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        typesStack.topAnchor.constraint(equalTo: pokemonTypeLabel.bottomAnchor, constant: 10).isActive = true
        typesStack.leadingAnchor.constraint(equalTo: pokemonTypeLabel.leadingAnchor, constant: 0).isActive = true
        typesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
        
        pokemonImageView.layer.borderWidth = 2
        pokemonImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
        
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.isScrollEnabled = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
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
    
    private func setupUI() {
        if let url = viewModel?.pokemonImageUrl {
            pokemonImageView.load(url: URL(string: url)!)
        }
        
        self.title = viewModel?.pokemonName.capitalized
        
        viewModel?.pokemonTypes.forEach({ type in
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.text = type
            
            typesStack.addArrangedSubview(label)
        })
        
        viewModel?.pokemonStats.forEach({ stat in
            let hStack = UIStackView()
            hStack.axis = .horizontal
            
            let keyLabel = UILabel()
            keyLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            keyLabel.text = "\(stat.key): "
            
            let valueLabel = UILabel()
            valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
            valueLabel.text = "\(stat.value)"
            
            hStack.addArrangedSubview(keyLabel)
            hStack.addArrangedSubview(valueLabel)
            
            statsStack.addArrangedSubview(hStack)
        })
    }
}
