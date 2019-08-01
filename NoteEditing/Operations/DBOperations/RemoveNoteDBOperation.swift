//
//  RemoveNoteDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Arkadiy Grigoryanc on 23.07.2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let uid: String
    private(set) var removingIndex: Int?
    
    init(uid: String, notebook: FileNotebook) {
        self.uid = uid
        super.init(notebook: notebook)
    }
    
    override func main() {
        print("RemoveNoteDBOperation", #function)
        removingIndex = notebook.remove(atUID: uid)
        try? notebook.write()
        finish()
    }
}
