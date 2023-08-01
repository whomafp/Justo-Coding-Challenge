//
//  Networking.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 27/07/23.
//

import Foundation
import Combine

public enum Result<T> {
    case success(T)
    case failure(Error)
}

class Networking {
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // MARK: - Private functions
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - Public function
    
    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data>) -> Void) {
        Networking.getData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }
    }
    
    /// fetch person from randomuser api
    /// returns Publisher<RandomPersonModel>
    func fetchPerson() -> some Publisher<RandomPersonModel, Error> {
        let url = URL(string: "https://randomuser.me/api/")!
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap(\.data)
            .decode(type: RandomPersonModel.self, decoder: jsonDecoder)
            .receive(on: RunLoop.main)
    }
    /// fetch person from randomuser api
    /// returns async RandomPersonModel
    func fetchPerson() async throws -> RandomPersonModel {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw ErrorApi.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ErrorApi.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(RandomPersonModel.self, from: data)
        } catch {
            throw ErrorApi.invalidResponse
        }
    }
    
}
enum ErrorApi: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}
