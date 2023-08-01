//
//  Model.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 27/07/23.
//

import Foundation

struct RandomPersonModel: Decodable, Hashable {
    var results: [Person]
}

struct Person: Decodable, Hashable {
    var gender: String
    var name: Name
    var location: Location
    var picture: Picture
    var dob: Age
    
    struct Age: Decodable, Hashable {
        var age: Int
    }
    
    struct Name: Decodable, Hashable {
        var first: String
    }
    
    struct Picture: Decodable, Hashable {
        var large: String
    }
    
    struct Location: Decodable, Hashable {
        var city: String
        var state: String
        var country: String
        var coordinates: Coordinates
        
        struct Coordinates: Decodable, Hashable {
            var latitude: String
            var longitude: String
        }
    }
}
