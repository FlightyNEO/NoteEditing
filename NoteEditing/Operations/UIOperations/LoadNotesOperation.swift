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
    
    private var notebook: FileNotebook
    private var loadFromDb: LoadNotesDBOperation?
    private let loadFromBackend: LoadNotesBackendOperation
    private var completion: CompletionHandler
    
    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue, completion: @escaping CompletionHandler) {
        self.notebook = notebook
        self.completion = completion
        
        loadFromBackend = LoadNotesBackendOperation()
        
        super.init()
        
        let loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        loadFromBackend.completionBlock = {
            if case .success(let notes) = self.loadFromBackend.loadResult! {
                self.notebook.add(notes)
            }
            self.loadFromDb = loadFromDb
            dbQueue.addOperation(loadFromDb)
        }
        
        addDependency(loadFromDb)
        addDependency(loadFromBackend)
        
        backendQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        print("LoadNotesOperation", #function)
        completionBlock = {
            self.notebook.add(self.loadFromDb!.notebook.notes)
            self.completion(.success(()))
        }
        finish()
    }
}
