//
//  NoteCell.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 19.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    
    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            colorView.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
