//
//  MainViewModelInput.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import Combine

struct MainViewModelInput {
    let fetchPersonDataPublisher = PassthroughSubject<Void, Never>()
}
