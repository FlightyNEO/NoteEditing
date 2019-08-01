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
    var result: LoadNotesBackendOperationResult?
    
    override func main() {
        //sleep(2) // Что-то происходит
        print("LoadNotesBackendOperation", #function)
        // Загружаем из бэкенда
        // if success
        // let notes = Notes(data)
        // result = .success(notes: notes)
        // else if failure
        result = .failure(.unreachable(message: "Failure mock"))
        finish()
    }
}
