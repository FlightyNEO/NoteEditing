//
//  RemoveNoteOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

enum RemoveNoteError: Error {
    case unreachable(message: String)
}

class RemoveNoteOperation: AsyncOperation {
    
    typealias CompletionHandler = (Result<Int?, RemoveNoteError>) -> Void
    
    private let uid: String
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private var completion: CompletionHandler
    
    //private(set) var result: Bool? = false
    
    init(uid: String, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue, completion: @escaping CompletionHandler) {
        
        self.uid = uid
        self.notebook = notebook
        self.completion = completion
        
        removeFromDb = RemoveNoteDBOperation(uid: uid, notebook: notebook)
        
        super.init()
        
        let saveToBackend = SaveNotesBackendOperation() // notes: self.removeFromDb.notebook.notes
        removeFromDb.completionBlock = {
            saveToBackend.notes = notebook.notes
            self.saveToBackend = saveToBackend
            backendQueue.addOperation(saveToBackend)
        }
        
        addDependency(saveToBackend)
        addDependency(removeFromDb)
        
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        print("RemoveNoteOperation", #function)
        completionBlock = {
            switch self.saveToBackend!.saveResult! {
            case .success:
                self.completion(.success(self.removeFromDb.removingIndex))
            case .failure(let error):
                self.completion(.failure(.unreachable(message: error.localizedDescription)))
            }
        }
        finish()
    }
}
