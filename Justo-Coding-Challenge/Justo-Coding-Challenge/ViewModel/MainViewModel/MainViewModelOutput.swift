//
//  MainViewModelOutput.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 31/07/23.
//

import Foundation
import Combine

struct MainViewModelOutput {
    let receivePersonDataPublisher = PassthroughSubject<Person, Never>()
}
