//
//  GistPatch.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 02.08.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

class GistPatch: Codable {
    private(set) var information: String?
    private(set) var files: [String: [String: String]]
    
    init(information: String?, files: [String: String]) {
        self.information = information
        self.files = files.reduce(into: [String: [String: String]]()) {
            $0[$1.key] = ["content": $1.value]
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case information = "description"
        case files
    }
}
