//
//  PokemonListCell.swift
//  PokeBuddy
//

import UIKit

class PokemonListCell: UITableViewCell {
    // MARK: - UI
    private let pokemonNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let pokemonImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.backgroundColor = .clear
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    func configure(viewModel: PokemonListCellViewModel) {
        pokemonNameLabel.text = viewModel.name
        
        if let image = viewModel.image {
            pokemonImageView.image = image
        
        } else {
            guard
                let stringUrl = viewModel.imageUrl,
                let url = URL(string: stringUrl) else { return }
            
            pokemonImageView.load(url: url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constraints

extension PokemonListCell {
    private func setupConstraints() {
        addSubview(pokemonImageView)
        addSubview(pokemonNameLabel)
    
        pokemonImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pokemonImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15).isActive = true
        
        pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 15).isActive = true
        pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
        pokemonNameLabel.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor).isActive = true
    }
}
