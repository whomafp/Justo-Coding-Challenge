//
//  FeatureViewModelOutputs.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 30/07/23.
//

import Foundation
import Combine

struct FeatureViewModelOutput {
    let receiveFeaturedDataPublisher = PassthroughSubject<[Person], Never>()
    let showActivityLoadingPublisher = PassthroughSubject<Bool, Never>()
    let isPaginatingDataPublisher = PassthroughSubject<Bool, Never>()
}
