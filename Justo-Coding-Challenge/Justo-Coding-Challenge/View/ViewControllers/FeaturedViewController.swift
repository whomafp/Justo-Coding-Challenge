//
//  LikedViewController.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 28/07/23.
//

import Foundation
import UIKit
import Combine

class FeaturedViewController: UICollectionViewController {

    enum Section: Int, CaseIterable {
        case grid
    }
    
    weak var coordinator: MainCoordinator?
    private var viewModel: FeaturedViewModelProtocol = FeaturedViewModel()
    private let viewModelinput = FeatureViewModelInput()
    
    @Published private var people: [Person] = []
    
    public var currentCell: PersonCollectionViewCell?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Person>!
    private var layout: UICollectionViewCompositionalLayout!

    private var cancellables = Set<AnyCancellable>()
    private var isPaginating = false
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func loadView() {
        super.loadView()
        observe()
        setupDataSource()
        setupCompositionalLayout()
        setupCollectionView()
        bind()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContraintsForActivity()
        viewModelinput.fetchFeaturedDataPublisher.send()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }

    private func setupNavigation(){
        self.view.backgroundColor = .background
        self.navigationItem.title = "Featured people"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.circle")?
            .withTintColor(.white),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(showAlert))
    }

    private func setupCollectionView(){
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cellId")
        collectionView.register(
            PersonCollectionViewCell.self,
            forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)
        collectionView.register(
            FooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
        collectionView.collectionViewLayout = layout
    }

    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { sectionIndex, env in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .grid:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)), subitems: [item])
                group.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                let section = NSCollectionLayoutSection(group: group)
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                section.boundarySupplementaryItems = [footer]
                return section
            }
        })
    }

    private func setupDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, personData in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .grid:
               guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PersonCollectionViewCell.identifier,
                    for: indexPath) as? PersonCollectionViewCell else {return UICollectionViewCell()}
                cell.configure(data: personData)
                cell.shadowDecorate()
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let footerView = self.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else { fatalError() }
            footerView.toggleLoading(isEnabled: isPaginating)
            return footerView
        }
    }

    private func observe() {
        $people
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadSnapshot()
            }.store(in: &cancellables)
    }

    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(people, toSection: .grid)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureContraintsForActivity(){
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
//MARK: Actions
extension FeaturedViewController {
    @objc
    private func showAlert() {
        coordinator?.showAlert(title: "Gumble",
                               message: "These are Gumble's featured people, pick someone you'd like to hang out with 😏")
    }
}
//MARK: Binding data
extension FeaturedViewController {
    func bind() {
        let output = self.viewModel.bind(input: self.viewModelinput)
        
        output
            .receiveFeaturedDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newPeople in
            self?.people.append(contentsOf: newPeople)
        }.store(in: &cancellables)
        
        output
            .showActivityLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] showActivity in
                showActivity ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        output
            .isPaginatingDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaginating in
                self?.isPaginating = isPaginating
            }
            .store(in: &cancellables)
        
    }
}
//MARK: CollectionView Delegates
extension FeaturedViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == people.count - 1 {
            isPaginating = true
            self.viewModelinput.fetchFeaturedDataPublisher.send()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = people[indexPath.row]
        coordinator?.showPreview(of: selectedPerson)
    }
}
