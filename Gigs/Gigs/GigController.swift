//
//  GigController.swift
//  Gigs
//
//  Created by krikaz on 3/15/20.
//  Copyright © 2020 thewire. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case badImage
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class GigController {
    var bearer: Bearer?
    private let baseUrl = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    var gigs: [Gig] = []
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        let logInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> ()) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigs = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigs)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error receiving gigs data: \(error)")
                completion(.failure(.otherError))
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
        }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> ()) {
        guard let bearer = bearer else {
            completion(.failure(.noAuth))
            return
        }
        
        let allGigs = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigs)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user data: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(gig))
        }.resume()
    }
}
