//
//  CheckView.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 07.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class CheckView: UIView {

    override func draw(_ rect: CGRect) {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = rect.midX
        
        let checkMarkRect = CGRect(x: rect.minX + 3, y: rect.minY + 3, width: rect.width - 6, height: rect.height - 6)
        drawCheckMark(checkMarkRect)
    }
    
    private func drawCheckMark(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle: CGFloat = 200
        var newPoint = CGPoint(x: 0, y: rect.midY)
        
        let bezier = UIBezierPath()
        bezier.move(to: newPoint)
        
        newPoint = CGPoint(x: rect.midX, y: rect.maxY)
        bezier.addLine(to: newPoint)
        
        newPoint = point(withCenter: center, andPoint: newPoint, forAngle: angle)
        bezier.addLine(to: newPoint)
        
        tintColor.set()
        bezier.stroke()
        
    }
    
    private func point(withCenter center: CGPoint, andPoint point: CGPoint, forAngle angle: CGFloat) -> CGPoint {
        let rx = point.x - center.x
        let ry = point.y - center.y
        let c = cos(angle.radians)
        let s = sin(angle.radians)
        
        return CGPoint(x: center.x + rx * c - ry * s,
                       y: center.y + rx * s + ry * c)
    }
    
}
