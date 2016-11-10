//
//  CustomActivityIndicator.swift
//  BygApp
//
//  Created by Prince Agrawal on 15/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {
    
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.mainScreen().bounds
        NSBundle.mainBundle().loadNibNamed("CustomActivityIndicator", owner: self, options: nil)
        self.view.frame = UIScreen.mainScreen().bounds
        self.addSubview(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
