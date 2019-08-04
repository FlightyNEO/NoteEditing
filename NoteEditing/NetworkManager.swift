//
//  NetworkManager.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 02.08.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

private let idGistKey = "idGist"

class NetworkManager {
    
    private init() {}
    static let manager = NetworkManager()
    
    private let token = "xxxxxxxxxxxx"
    private let login = "xxxxxxxxxxxx"
    private lazy var idGist: String = {
        UserDefaults().string(forKey: idGistKey) ?? ""
    }()
    
    private(set) var fileName = "ios-course-notes-db"
    
    private let session = URLSession.shared
    
    private enum URLStrings {
        private static let baseURL = "https://api.github.com/"
        fileprivate static var users: String { return baseURL + "users" }
        fileprivate static var gists: String { return baseURL + "gists" }
    }
    
    enum NetworkError: Error {
        case error(message: String)
        case cannotParse
        case cannotEdit
    }
    
    // MARK: - Private methods
    private func addToken(to request: inout URLRequest) {
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    
    private func saveIdGist() {
        UserDefaults().set(idGist, forKey: idGistKey)
    }
    
    // MARK: - GET Requests
    func fetchGist(completion: @escaping (Result<Gist, NetworkError>) -> Void) {
        let url = URL(string: URLStrings.gists)!.appendingPathComponent(idGist)
        var request = URLRequest(url: url)
        addToken(to: &request)
        
        session.dataTask(with: request) { data, response, error in
                    
            guard error == nil else {
                completion(.failure(.error(message: error!.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.error(message: "No data")))
                return
            }
            
            do {
                let gist = try JSONDecoder().decode(Gist.self, from: data)
                completion(.success(gist))
            } catch {
                completion(.failure(.cannotParse))
            }
            
        }.resume()
    }
    
    // MARK: - POST Requests
    func createGist(_ gist: GistPatch, completion: ((Result<Void, NetworkError>) -> Void)? = nil) {
        
        do {
            let url = URL(string: URLStrings.gists)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            addToken(to: &request)
            request.httpBody = try JSONEncoder().encode(gist)
            
            session.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion?(.failure(.error(message: error!.localizedDescription)))
                    return
                }
                
                guard let code = (response as? HTTPURLResponse)?.statusCode, code == 201 else {
                    completion?(.failure(.error(message: "Code error")))
                    return
                }
                
                guard let data = data else {
                    completion?(.failure(.error(message: "No data")))
                    return
                }
                
                if let gist = try? JSONDecoder().decode(Gist.self, from: data) {
                    self.idGist = gist.id
                    self.saveIdGist()
                    completion?(.success(()))
                } else {
                    completion?(.failure(.cannotParse))
                }
                
            }.resume()
            
        } catch {
            completion?(.failure(.error(message: error.localizedDescription)))
        }
    }
    
    // MARK: - PATCH methods
    func editGist(_ gist: GistPatch, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        do {
            let url = URL(string: URLStrings.gists)!.appendingPathComponent(idGist)
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            addToken(to: &request)
            request.httpBody = try JSONEncoder().encode(gist)
            
            session.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(.failure(.error(message: error!.localizedDescription)))
                    return
                }
                
                guard let code = (response as? HTTPURLResponse)?.statusCode, code == 200 else {
                    completion(.failure(.cannotEdit))
                    return
                }
                
                completion(.success(()))
                
            }.resume()
            
        } catch {
            completion(.failure(.error(message: error.localizedDescription)))
        }
        
    }
    
}
