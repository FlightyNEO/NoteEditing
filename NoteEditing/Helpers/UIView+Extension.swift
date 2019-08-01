//
//  UIImage+Extension.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 08.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

extension UIView {
    func pixelColor(atLocation point: CGPoint) -> UIColor {
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData: [CUnsignedChar] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData,
                                width: 1,
                                height: 1,
                                bitsPerComponent: 8,
                                bytesPerRow: 4,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        
        let red:    CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green:  CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue:   CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha:  CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        print(color)
        return color
    }
    
}
