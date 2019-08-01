//
//  LoadNotesOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private var notebook: FileNotebook?
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        let loadFromBackend = LoadNotesBackendOperation()
        loadFromDb.completionBlock = {
            self.loadFromBackend = loadFromBackend
            backendQueue.addOperation(loadFromBackend)
        }
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        dbQueue.addOperation(loadFromDb)
    }
    
    override func main() {
        print("LoadNotesOperation", #function)
        switch loadFromBackend!.result! {
        case .success(let backendNotes):
            
            let dbNotes = loadFromDb.notebook.notes
            if dbNotes != backendNotes {
                self.notebook = FileNotebook(notes: backendNotes)
            } else {
                self.notebook = FileNotebook(notes: dbNotes)
            }
            
            result = true
        case .failure(let message):
            print(message)
            result = false
        }
        finish()
    }
}
