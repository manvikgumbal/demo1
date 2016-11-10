//
//  RateUsView.swift
//  BygApp
//
//  Created by Manish on 30/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol rateUsViewDelegate {
    func didRateUs(withRating: Int)
}

class RateUsView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet var rateButtons: [UIButton]!
    
    var ratings = 1
    weak var delegate: rateUsViewDelegate?
    
    //MARK: UIView Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomPopUpView.keyboardNotification(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUIAppearence()
    }
    
    func handleTap() {
        self.removeFromSuperview()
    }

    
    //MARK: Private Methods
    private func nibSetup() {
        backgroundColor = .clearColor()
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        return nibView
    }
    
    private func updateUIAppearence() {
        rateView.layer.cornerRadius = 10.0
        rateView.layer.masksToBounds = true
    }

    
    //MARK: IBactions
    
    @IBAction func rateButtonAction(sender: UIButton) {
        ratings = sender.tag
        for button in rateButtons {
            if button.tag <= sender.tag {
                button.selected = true
            }
            else {
                button.selected = false
            }
        }
    }
    
    @IBAction func rateUsButtonAction(sender: UIButton) {
        DataManager.isRateDone = true
        delegate?.didRateUs(ratings)
        self.removeFromSuperview()
    }
    
    @IBAction func notNowButtonAction(sender: UIButton) {
        self.removeFromSuperview()
    }
}
