//
//  ColorCell.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 07.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var checkView: CheckView! {
        didSet {
            checkView.transform = CGAffineTransform(rotationAngle: CGFloat(-10).radians)
        }
    }
    
    var isCheck: Bool = false {
        didSet {
            checkView?.isHidden = !isCheck
        }
    }
    
}
