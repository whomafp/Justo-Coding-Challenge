//
//  ViewController.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 27/07/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
        
    weak var coordinator: MainCoordinator?
    
    @Published var people: [Person] = []
    
    private let viewModelinput = MainViewModelInput()
    private var viewModel: MainViewModelProtocol = MainViewViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var loading: LoadingView?
    
    let buttonDeslike: UIButton = {
        let button = UIButton()
        button.size(size: .init(width: 64, height: 64))
        button.setImage(UIImage(named: "dislike"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .text
        button.layer.cornerRadius = 32
        button.clipsToBounds = true
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.masksToBounds = true
        return button
    }()
    
    let buttonLike: UIButton = {
        let button = UIButton()
        button.size(size: .init(width: 64, height: 64))
        button.setImage(UIImage(named: "like"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .mainColor
        button.layer.cornerRadius = 32
        button.clipsToBounds = true
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "Gumble"
        self.view.backgroundColor = .background
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(navigateToFeatured))
    }
    
    private func setupView(){
        loading = LoadingView(frame: view.frame)
        view.insertSubview(loading!, at: 0)
        bind()
        setupButtonStack()
        viewModelinput.fetchPersonDataPublisher.send()
    }
    
    private func addCards() {
        for (index, person) in people.enumerated() {
            let cardView = PersonView()
            cardView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            cardView.center = view.center
            cardView.person = person
            cardView.completion = { (person) in
                self.coordinator?.showPreview(of: person)
            }
            cardView.tag = index
            view.addSubview(cardView)
        }
    }
    
    func animateCard() {
        if let _ = people.last,
           let view = view.subviews.last as? PersonView {
            let buttons = [buttonLike, buttonDeslike]
            buttons.forEach({$0.isUserInteractionEnabled = false})
            UIView.animate(withDuration: 0.4) {
                view.alpha = 0
            } completion: { [weak self] _ in
                buttons.forEach({$0.isUserInteractionEnabled = true})
                self?.removeCard(view)
                self?.viewModelinput.fetchPersonDataPublisher.send()
            }
        }
    }
    
    func setupButtonStack() {
        let stackView = UIStackView(arrangedSubviews: [UIView(), buttonDeslike, buttonLike, UIView()])
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.fillView(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: -30, right: -16)
        )
        addTapButtons()
    }
    
    func removeCard(_ card: PersonView) {
        card.removeFromSuperview()
        people.removeAll()
    }
    
    func addTapButtons() {
        buttonDeslike.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        buttonLike.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
}

//MARK: Binding data
extension MainViewController {
    func bind() {
        let output = self.viewModel.bind(input: self.viewModelinput)
        output
            .receivePersonDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] person in
                self?.people.append(person)
                self?.addCards()
            }.store(in: &cancellables)
    }
}

//MARK: Actions
extension MainViewController {
    @objc
    private func navigateToFeatured() {
        coordinator?.showFeaturedPeople()
    }
    
    @objc
    func didTapButton() {
        animateCard()
    }
}
