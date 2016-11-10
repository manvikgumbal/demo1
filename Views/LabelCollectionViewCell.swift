//
//  LabelCollectionViewCell.swift
//  BygApp
//
//  Created by Prince Agrawal on 27/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    override var selected: Bool {
        didSet {
            if selected {
                titleLabel.font = UIFont.BYGFont.Bold.fontWithSize(titleLabel.font.pointSize)
            }
            else {
                titleLabel.font = UIFont.BYGFont.Regular.fontWithSize(titleLabel.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
}
