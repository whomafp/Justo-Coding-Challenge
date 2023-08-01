//
//  Coordinator.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    func start()
    func showPreview(of person: Person)
    func getBackToView()
    func showAlert(title: String, message: String)
    func showFeaturedPeople()
}

//MARK: Set custom NavigationController from MainCoordinator
extension Coordinator where Self: MainCoordinator {
    func configureNavigation(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.text ?? UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.tintColor = .mainColor
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}
