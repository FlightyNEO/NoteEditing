//
//  Sequence+Extension.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 24.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
    mutating func removeDuplicates() {
        self = uniqueElements as! Self
    }
}
