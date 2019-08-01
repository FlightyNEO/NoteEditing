//
//  UIColor+Extension.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 08.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 0xFF) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(rgba: Int) {
        self.init(red: (rgba >> 16) & 0xFF,
                  green: (rgba >> 8) & 0xFF,
                  blue: rgba & 0xFF,
                  alpha: (rgba >> 24) & 0xFF)
    }
    
    var hexString: String {
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

