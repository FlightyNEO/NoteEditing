//
//  LoadNotesOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

enum LoadNoteError: Error {
    case unreachable(message: String)
}

class LoadNotesOperation: AsyncOperation {
    
    typealias CompletionHandler = (Result<Void, LoadNoteError>) -> Void
    
    private var notebook: FileNotebook?
    private var loadFromDb: LoadNotesDBOperation?
    private let loadFromBackend: LoadNotesBackendOperation
    private var completion: CompletionHandler
    
    //private(set) var result: Bool? = false
    
    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue, completion: @escaping CompletionHandler) {
        
        self.notebook = notebook
        self.completion = completion
        
        self.loadFromBackend = LoadNotesBackendOperation()
        
        super.init()
        
        let loadFromDb = LoadNotesDBOperation(notebook: notebook)
        loadFromBackend.completionBlock = {
            switch self.loadFromBackend.loadResult! {
            case .success(let notes):
                self.notebook?.add(notes)
                //self.notebook = FileNotebook(notes: notes)
                self.removeDependency(loadFromDb)
            case .failure(_):
                self.loadFromDb = loadFromDb
                //self.addDependency(loadFromDb)
                dbQueue.addOperation(loadFromDb)
            }
        }
        
        addDependency(loadFromDb)
        addDependency(loadFromBackend)
        
        dbQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        print("LoadNotesOperation", #function)
        completionBlock = {
            if self.notebook != nil {
                self.completion(.success(()))
            } else {
                self.completion(.failure(.unreachable(message: "error")))
            }
            
        }
        finish()
    }
}
