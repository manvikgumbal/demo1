//
//  EmptyScreenView.swift
//  BygApp
//
//  Created by Prince Agrawal on 02/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@IBDesignable class EmptyScreenView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
   
    
    weak var delegate: MeCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    convenience init(image: UIImage, title: String, description: String, isButtonHidden:Bool = true, buttonTitle:String = "Retry", buttonAction: Selector = nil, actionTarget: AnyObject? = nil) {
        self.init()
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.setTitle(buttonTitle, forState: .Normal)
        actionButton.hidden = isButtonHidden
        if(buttonAction != nil) {
            actionButton.addTarget(actionTarget ?? self, action: buttonAction, forControlEvents: .TouchUpInside)
        }
    }
    
    
    //MARK: IBActions
    @IBAction func onInfoButtonTap(sender: UIButton) {
        self.delegate?.didTapOnInfoButton()
    }
    
    @IBAction func onAddToWallet(sender: UIButton) {
        self.delegate?.didTapOnAddToWalletButton()
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
}
