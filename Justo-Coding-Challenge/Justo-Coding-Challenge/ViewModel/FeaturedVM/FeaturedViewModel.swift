//
//  FeaturedViewModel.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 29/07/23.
//

import Foundation
import UIKit
import Combine

protocol FeaturedViewModelProtocol {
    func bind(input: FeatureViewModelInput) -> FeatureViewModelOutput
    var output: FeatureViewModelOutput { get }
}

class FeaturedViewModel: FeaturedViewModelProtocol{
    private let network = Networking()
    var output = FeatureViewModelOutput()
    private var cancellables = Set<AnyCancellable>()
    
    init() { }
    
    func fetchNewPeople() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) { [weak self] in
            
            guard let self = self else {return}
            
            let peoplePublishers = (1...4).map { _ in
                return self.network.fetchPerson()
            }
            
            var newPeople = [Person]()
            
            Publishers
                .MergeMany(peoplePublishers)
                .collect()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.output.receiveFeaturedDataPublisher.send(newPeople)
                        self.output.showActivityLoadingPublisher.send(false)
                        self.output.isPaginatingDataPublisher.send(false)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { results in
                    let people = results.compactMap({$0.results.first})
                    newPeople.append(contentsOf: people)
                })
                .store(in: &self.cancellables)
        }
    }
    
    func bind(input: FeatureViewModelInput) -> FeatureViewModelOutput {
        input.fetchFeaturedDataPublisher.sink {
            self.fetchNewPeople()
        }
        .store(in: &cancellables)
        return output
    }
}
