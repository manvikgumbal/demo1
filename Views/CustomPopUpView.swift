//
//  CustomPopUpView.swift
//  BygApp
//
//  Created by Manish on 30/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol CustomPopViewDelegate {
    func didTapDoneButton(text: String?)
}

class CustomPopUpView: UIView {

    //MARK: IBOutlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: CustomPopViewDelegate?
    
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
        if(dataTextField.isFirstResponder()) {
            dataTextField.resignFirstResponder()
        }
        else {
            self.removeFromSuperview()
        }
    }
    
    //MARK: Load Data
    func loadData(logoImageString: String?, titleString: String?, descriptionString: String?, textFieldPlaceholder: String?, mainButtonTitle: String?, cancelButtonTitle: String?) {
        
        if logoImageString != nil {
            logoImageView.image = UIImage(named: logoImageString!)
        }
        titleLabel.text = titleString!
        descriptionLabel.text = descriptionString!
        
        if(textFieldPlaceholder != nil) {
            dataTextField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder!)
        }
        else {
            dataTextField.userInteractionEnabled = false
            textFieldHeightConstraint.constant = 0.0
        }
        if(mainButtonTitle != nil) {
            doneButton.setTitle(mainButtonTitle!, forState: .Normal)
        }
        else {
            buttonHeightConstraint.constant = 0.0
            doneButton.userInteractionEnabled = false
        }
        if(cancelButtonTitle != nil) {
            cancelButton.setTitle("No Thanks!", forState: .Normal)
        }
        else {
            cancelButton.hidden = true
            cancelButton.userInteractionEnabled = false
        }
        self.layoutIfNeeded()
    }
    
    //MARK: Keyboard Delegates
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.popupView.frame.origin.y = +50
            } else {
                self.popupView.frame.origin.y = -50
            }
            UIView.animateWithDuration(duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
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
        popupView.layer.cornerRadius = 10.0
        popupView.layer.masksToBounds = true
        dataTextField.setBorderWithRadius(0.5, borderColor: UIColor.lightGrayColor(), radius: 3.0)
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func doneButtonAction(sender: UIButton) {
        self.removeFromSuperview()
        delegate?.didTapDoneButton(dataTextField.text!)
    }
    
}
