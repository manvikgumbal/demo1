//
//  RatingView.swift
//  BygApp
//
//  Created by Manish on 6/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol RatingViewDelegate {
    func didTapSubmitButtonWithRating(rating: Double, comments: String?)
}

@IBDesignable class RatingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var commentsTextView: UITextView!
    var rating = Int()
    
    weak var delegate: RatingViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RatingView.keyboardNotification(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil)
        
        commentsTextView.text = kRatePlaceholderText
        commentsTextView.textColor = UIColor.lightGrayColor()
        commentsTextView.delegate = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUIAppearence()
    }
    
    //MARK: IBActions
    
    @IBAction func ratingButtonAction(sender: UIButton) {
        
        for index in 1 ..< 6 {
            (self.view.viewWithTag(index) as? UIButton)?.selected = false
        }
        for index in 1 ..< sender.tag+1 {
            (self.view.viewWithTag(index) as? UIButton)?.selected = true
        }
        rating  = sender.tag

    }
    
    @IBAction func submitButtonAction(sender: UIButton) {
        if(rating>0) {
            if(commentsTextView.text! == kRatePlaceholderText) {
                delegate?.didTapSubmitButtonWithRating(Double(rating), comments: nil)
            }
            else {
                delegate?.didTapSubmitButtonWithRating(Double(rating), comments: commentsTextView.text!)
            }
        }
    }
    
    func handleTap() {
        if(commentsTextView.isFirstResponder()) {
            commentsTextView.resignFirstResponder()
        }
        else {
            self.removeFromSuperview()
        }
    }
    
    
    //MARK: Keyboard Delegates
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.ratingView.frame.origin.y = +100
            } else {
                self.ratingView.frame.origin.y = -100
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
        ratingView.layer.cornerRadius = 10.0
        ratingView.layer.masksToBounds=true
    }

}

//MARK: Text view Delegate

extension RatingView : UITextViewDelegate {

    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidChange(textView: UITextView) {
        if((textView.text as NSString).length == 0) {
            textView.text = kRatePlaceholderText
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRangeFromPosition(newPosition, toPosition: newPosition)
            textView.textColor = UIColor.lightGrayColor()
        }
        else {
            if(textView.text.containsString(kRatePlaceholderText)) {
                textView.text = textView.text.stringByReplacingOccurrencesOfString(kRatePlaceholderText, withString: "")
            }
            textView.textColor=UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text=="") {
            textView.text = kRatePlaceholderText
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
}
