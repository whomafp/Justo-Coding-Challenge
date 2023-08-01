//
//  PersonView.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import UIKit

class PersonView: UIView {

    var person: Person? {
        didSet{
            if let person = person {
                photoPerson.loadThumbnail(urlSting: person.picture.large)
                nameLabel.text = person.name.first
                ageLabel.text = "\(person.dob.age)"
                countryLabel.text = "\(person.location.city), \(person.location.country)"
            }
        }
    }
    
    var completion: ((Person) -> Void)?

    let photoPerson: UIImageView = .createUIImageView()
    
    let nameLabel: UILabel = .textBoldLabel(
        size: 32
    )
    
    let ageLabel: UILabel = .textLabel(
        size: 25
    )
    
    let countryLabel: UILabel = .textLabel(
        size: 15
    )
    
    let iconDeslike: UIImageView = .createUIImageView("card-deslike", .init(width: 70, height: 60), isIcon: true)
    let iconLike: UIImageView = .createUIImageView("card-like", .init(width: 70, height: 60), isIcon: true)
    
    lazy var nameAgeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, UIView()])
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameAgeStackView, countryLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
        addSubviews()
        configureContraints()
    }
    
    private func setupView(){
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        nameLabel.addShadow()
        ageLabel.addShadow()
        countryLabel.addShadow()
        let tapName = UITapGestureRecognizer(target: self, action: #selector(didSelectPerson))
        photoPerson.isUserInteractionEnabled = true
        photoPerson.addGestureRecognizer(tapName)
    }
    
    private func addSubviews(){
        addSubview(photoPerson)
        addSubview(iconDeslike)
        addSubview(iconLike)
        addSubview(stackView)
    }
    
    private func configureContraints(){
        iconDeslike.fillView(
            top: topAnchor,
            leading: nil,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(top: 20, left: 0, bottom: 0, right: -20)
        )
        
        iconLike.fillView(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        
        stackView.fillView(
            top: nil,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: -16, right: -16)
        )
        photoPerson.fillSuperView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
// MARK: - Actions
extension PersonView{
    @objc func didSelectPerson() {
        if let user = person {
            completion?(user)
        }
    }
}
