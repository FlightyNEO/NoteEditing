//
//  LoadNotesBackendOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

enum LoadNotesBackendOperationResult {
    case success(notes: Notes)
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var loadResult: LoadNotesBackendOperationResult?
    private let networkManager = NetworkManager.manager
    
    override func main() {
        print("LoadNotesBackendOperation", #function)
        
        networkManager.fetchNotes { result in
            
            switch result {
            case .success(let notes):
                self.loadResult = .success(notes: notes)
//                do {
//                    let notes = try gist.getNotes(at: self.networkManager.fileName)
//                    self.loadResult = .success(notes: notes)
//                } catch {
//                    self.loadResult = .failure(.unreachable(message: error.localizedDescription))
//                }
                
            case .failure(let error):
                self.loadResult = .failure(.unreachable(message: error.localizedDescription))
            }
            self.finish()
        }
        
    }
    
}
