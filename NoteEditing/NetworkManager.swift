//
//  NetworkManager.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 02.08.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

private let idGistKey = "idGist"

extension NetworkManager {
    enum NetworkError: Error {
        case error(message: String)
        case cannotParse
        case cannotEdit
    }
}

// MARK: -
class NetworkManager {
    
    private init() {}
    static let manager = NetworkManager()
    
    private struct Github {
        private init() { }
        static var token = "xxxxxxxxxxxx"
        static let clientId = "1cd49dc7d1d81bab5b87"
        static let clientSecret = "f7128484986e7e9dfbc6cfa3b5581328af97fbce"
        static let scope = "gist"
        static let fileName = "ios-course-notes-db"
        static let redirectUrl = "https://github.com/"
    }
    
    
    private lazy var idGist: String = {
        UserDefaults().string(forKey: idGistKey) ?? ""
    }()
    
    private let session = URLSession.shared
    
    private enum URLStrings {
        
        private static let baseURL = "https://api.github.com/"
        static var users: String { return baseURL + "users" }
        static var gists: String { return baseURL + "gists" }
        
        enum Authorization {
            private static let baseURL = "https://github.com/login/oauth/"
            static var authorize: String { return baseURL + "authorize" }
            static var access_token: String { return baseURL + "access_token" }
        }
        
    }
    
    // MARK: - Private methods
    private func addToken(to request: inout URLRequest) {
        request.setValue("token \(Github.token)", forHTTPHeaderField: "Authorization")
    }
    
    private func saveIdGist() {
        UserDefaults().set(idGist, forKey: idGistKey)
    }
    
    // MARK: - GET Requests
    func fetchNotes(completion: @escaping (Result<Notes, NetworkError>) -> Void) {
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
                let notes = try gist.getNotes(at: Github.fileName)
                completion(.success(notes))
            } catch {
                completion(.failure(.cannotParse))
            }
            
        }.resume()
    }
    
    // MARK: - POST Requests
    func createNotes(_ notes: Notes, completion: ((Result<Void, NetworkError>) -> Void)? = nil) {
        
        do {
            let url = URL(string: URLStrings.gists)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            addToken(to: &request)
            
            let gist = try GistPatch(fileName: Github.fileName, notes: notes)
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
    func editNotes(_ notes: Notes, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        do {
            let url = URL(string: URLStrings.gists)!.appendingPathComponent(idGist)
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            addToken(to: &request)
            
            let gist = try GistPatch(fileName: Github.fileName, notes: notes)
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

// MARK: - Authorization
extension NetworkManager {
    
    var authorizationRequest: URLRequest {
        var urlComponents = URLComponents(string: URLStrings.Authorization.authorize)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Github.clientId),
            URLQueryItem(name: "redirect_uri", value: Github.redirectUrl),
            URLQueryItem(name: "scope", value: Github.scope)
        ]
        return URLRequest(url: urlComponents!.url!)
    }
    
    func authorization(url: URL, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        guard
            let queryItem = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
            let code = queryItem.first(where: { $0.name == "code" })?.value else {
                completion(.failure(.error(message: "Can't get code")))
                return
        }
        
        var urlComponents = URLComponents(string: URLStrings.Authorization.access_token)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Github.clientId),
            URLQueryItem(name: "client_secret", value: Github.clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
                let token = try JSONDecoder().decode(Token.self, from: data)
                Github.token = token.access
                completion(.success(()))
            } catch {
                completion(.failure(.cannotParse))
            }
            
        }.resume()
        
    }
    
}
