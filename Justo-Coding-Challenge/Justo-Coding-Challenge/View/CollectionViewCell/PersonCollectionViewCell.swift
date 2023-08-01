//
//  personCellCollectionViewCell.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 28/07/23.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCell"
    
    private let placeholderImage = UIImage(systemName: "photo.fill")?
        .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = placeholderImage
        return imageView
    }()
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .text
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.backgroundColor = .white
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .mainColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        setupPersonImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Person){
        personNameLabel.text = data.name.first
        countryLabel.text = data.location.country
        ageLabel.text = "Age \(data.dob.age)"
        personImageView.loadThumbnail(urlSting: data.picture.large)
    }
    
    private func setupPersonImage(){
        layoutIfNeeded()
        personImageView.layer.cornerRadius = (personImageView.frame.size.width ) / 2
        personImageView.clipsToBounds = true
        personImageView.layer.borderWidth = 3.0
        personImageView.layer.borderColor = UIColor.mainColor?.cgColor
    }
    
    private func configureConstraints(){
        contentStackView.addArrangedSubview(personNameLabel)
        contentStackView.addArrangedSubview(ageLabel)
        
        contentView.addSubview(personImageView)
        contentView.addSubview(contentStackView)
        contentView.addSubview(countryLabel)
        NSLayoutConstraint.activate([
            personImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor),
            personImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            personImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
    }
}
