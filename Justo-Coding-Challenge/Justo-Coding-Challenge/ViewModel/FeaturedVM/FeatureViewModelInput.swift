//
//  FeatureViewModelInput.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import Combine

struct FeatureViewModelInput {
    let fetchFeaturedDataPublisher = PassthroughSubject<Void, Never>()
    let showActivityLoadingPublisher = PassthroughSubject<Void, Never>()
    let isPaginatingDataPublisher = PassthroughSubject<Void, Never>()
}
