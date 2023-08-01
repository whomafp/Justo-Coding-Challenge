//
//  PreviewPersonViewController.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 29/07/23.
//

import Foundation
import UIKit
import MapKit

class PreviewPersonViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var aboutContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 10
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let introduceSubheaderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "INTRODUCE"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.mainColor, for: .normal)
        button.setTitle("Follow", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainColor?.cgColor
        button.contentEdgeInsets = UIEdgeInsets(
            top: 5,
            left: 15,
            bottom: 5,
            right: 15
        )
        return button
    }()
    
    private let locationSubheaderLabel: UILabel = {
        let label = UILabel()
        label.text = "LOCATION"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "CloseButton"), for: .normal)
        button.tintColor = .mainColor
        button.isUserInteractionEnabled = true
        button.addShadow()
        return button
    }()
    
    private (set) var person: Person
    
    weak var coordinator: MainCoordinator?
    
    let annotation1 = MKPointAnnotation()
    
    init(person: Person){
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupView(){
        addSubviews()
        configureContraints()
        configurePersonInformation()
        lookForPersonLocation()
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        aboutContainerView.addSubview(personNameLabel)
        aboutContainerView.addSubview(locationLabel)
        aboutContainerView.addSubview(followButton)
        aboutContainerView.addSubview(introduceSubheaderLabel)
        aboutContainerView.addSubview(introduceLabel)
        aboutContainerView.addSubview(locationSubheaderLabel)
        aboutContainerView.addSubview(mapView)
        scrollView.addSubview(aboutContainerView)
        scrollView.addSubview(headerContainerView)
        headerContainerView.addSubview(personImageView)
        headerContainerView.addSubview(closeButton)
    }
    
    private func configureContraints(){
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: aboutContainerView.topAnchor),
            personNameLabel.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor),
            personNameLabel.trailingAnchor.constraint(equalTo: followButton.leadingAnchor),
            
            followButton.topAnchor.constraint(equalTo: personNameLabel.topAnchor),
            followButton.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor, constant: -5),
            
            locationLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            introduceSubheaderLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor,
                                                         constant: 50),
            introduceSubheaderLabel.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor),
            introduceSubheaderLabel.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor),
            
            introduceLabel.topAnchor.constraint(equalTo: introduceSubheaderLabel.bottomAnchor,
                                                constant: 20),
            introduceLabel.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor),
            introduceLabel.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor),
            
            locationSubheaderLabel.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor,
                                                        constant: 20),
            locationSubheaderLabel.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor),
            locationSubheaderLabel.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: locationSubheaderLabel.bottomAnchor, constant: 30),
            mapView.heightAnchor.constraint(equalToConstant: 400),
            mapView.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: aboutContainerView.bottomAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.topAnchor.constraint(equalTo: headerContainerView.topAnchor,
                                             constant: 60),
            closeButton.leftAnchor.constraint(equalTo: headerContainerView.leftAnchor,
                                              constant: 30),
            
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            aboutContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                                    constant: 280),
            aboutContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                        constant: 10),
            aboutContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                         constant: -10),
            aboutContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                       constant: -10),
            
            
            headerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            personImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            personImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            personImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        
        let headerContainerViewBottom: NSLayoutConstraint!
        let imageViewTopConstraint: NSLayoutConstraint!
        headerContainerViewBottom = self.headerContainerView.bottomAnchor.constraint(equalTo: self.personNameLabel.topAnchor, constant: -10)
        headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerContainerViewBottom.isActive = true
        
        
        
        imageViewTopConstraint = self.personImageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
    }
    
    private func lookForPersonLocation() {
        let personCoordinates = (
            lat: Double(person.location.coordinates.latitude ) ?? 0.0,
            lon: Double(person.location.coordinates.longitude ) ?? 0.0)
        
        let initialLocation = CLLocation(
            latitude: personCoordinates.lat,
            longitude: personCoordinates.lat)
        
        let region = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000000)
        
        annotation1.title = "\(person.name.first) is here!"
        
        annotation1.coordinate = CLLocationCoordinate2D(
            latitude: personCoordinates.lat,
            longitude: personCoordinates.lat)
        
        mapView.addAnnotation(annotation1)
        
        DispatchQueue.main.async { [weak self] in
            self?.mapView.setCameraBoundary(
                MKMapView.CameraBoundary(coordinateRegion: region),
                animated: true)
            self?.mapView.setCameraZoomRange(zoomRange, animated: true)
            self?.mapView.centerToLocation(initialLocation)
        }
        
    }
    
    private func configurePersonInformation(){
        personImageView.loadThumbnail(urlSting: person.picture.large)
        personNameLabel.text = "\(person.name.first.uppercased()) •"
        locationLabel.text = "\(person.location.city), \(person.location.country)"
    }
    
    
}

//MARK: Actions
extension PreviewPersonViewController {
    @objc
    func closeButtonDidTap() {
        coordinator?.getBackToView()
    }
}
