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
    
    enum GistPatchError: Error {
        case initilizationError
    }
    
    init(information: String?, files: [String: String]) {
        self.information = information
        self.files = files.reduce(into: [String: [String: String]]()) {
            $0[$1.key] = ["content": $1.value]
        }
    }
    
    convenience init(fileName: String, notes: Notes) throws {
        do {
            let data = try JSONEncoder().encode(notes)
            guard let content = String(data: data, encoding: .utf8) else {
                throw GistPatchError.initilizationError
            }
            let files = [fileName : content]
            self.init(information: fileName, files: files)
        } catch {
            throw error
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case information = "description"
        case files
    }
}
