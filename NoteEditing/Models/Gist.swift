//
//  Gist.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 02.08.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

typealias Gists = [Gist]

class Gist: Decodable {
    let files: [String: GistFile]
    let id: String
}

extension Gist {
    func getNotes(at fileName: String) throws -> Notes {
        do {
            let gistFile = self.files.first { $0.key == fileName }?.value
            
            guard let data = gistFile?.content.data(using: .utf8) else {
                throw LoadNoteError.unreachable(message: "error")
            }
            let notes = try JSONDecoder().decode(Notes.self, from: data)
            return notes
            
        } catch let error {
            throw error
        }
    }
    
}
