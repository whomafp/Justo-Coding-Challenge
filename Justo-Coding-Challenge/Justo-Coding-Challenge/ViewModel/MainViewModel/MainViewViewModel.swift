//
//  MainViewModel.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    func bind(input: MainViewModelInput) -> MainViewModelOutput
    var output: MainViewModelOutput { get }
}

class MainViewViewModel: MainViewModelProtocol {
    
    private let network = Networking()
    var output = MainViewModelOutput()
    private var cancellables = Set<AnyCancellable>()
    
    init() { }
    
    func fetchPerson() async {
        Task {
            do {
                let response = try await network.fetchPerson()
                guard let person = response.results.first else { return }
                output.receivePersonDataPublisher.send(person)
            } catch{
                print()
            }
            
        }
    }
    
    func bind(input: MainViewModelInput) -> MainViewModelOutput  {
        input.fetchPersonDataPublisher.sink { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchPerson()
            }
        }
        .store(in: &cancellables)
        return output
    }
    
}
