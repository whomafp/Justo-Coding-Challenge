//
//  MainCoordinator.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        configureNavigation()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFeaturedPeople(){
        let vc = FeaturedViewController(collectionViewLayout: .init())
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPreview(of person: Person) {
        let vc = PreviewPersonViewController(person: person)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func getBackToView() {
        navigationController.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
}
