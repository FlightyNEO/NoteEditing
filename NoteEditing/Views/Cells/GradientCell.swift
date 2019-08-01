//
//  GradientCell.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 06.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class GradientCell: UICollectionViewCell {
    
    @IBOutlet weak var checkView: CheckView! {
        didSet {
            checkView.transform = CGAffineTransform(rotationAngle: CGFloat(-10).radians)
        }
    }
    @IBOutlet weak var gradientView: GradientView!
    
    var isCheck: Bool = false {
        didSet {
            checkView?.isHidden = !isCheck
        }
    }
    
}
