//
//  LoadNotesDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
//    override init(notebook: FileNotebook) {
//        super.init(notebook: notebook)
//    }
    
    override func main() {
        print("LoadNotesDBOperation", #function)
        guard let newNotebook = try? FileNotebook.read() else { return }
        notebook = newNotebook
        finish()
    }
    
}
