//
//  GradientView.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 06.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var colors:     [UIColor] = [.black, .white] { didSet { updateColors() }}
    var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateColors()
    }
    
    // MARK: - Private methods
    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    private func updateColors() {
        gradientLayer.colors    = colors.map { $0.cgColor }
    }
}
