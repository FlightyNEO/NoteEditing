//
//  String+Extension.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 08.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

extension String {
    var hexInt: UInt32 {
        let hexString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: self)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        return color
    }
}
