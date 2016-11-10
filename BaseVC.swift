//
//  BaseVC.swift
//  BygApp
//
//  Created by Prince Agrawal on 25/06/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    @IBInspectable var imageForEmptyScreen:UIImage = UIImage(named:"workoutNow")! {
        didSet {
            emptyview.imageView.image = imageForEmptyScreen
        }
    }
    @IBInspectable var titleForEmptyScreen:String = "uh oh" {
        didSet {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                titleForEmptyScreen = bundle.localizedStringForKey(self.titleForEmptyScreen, value:"", table: nil)
            #else
                titleForEmptyScreen = NSLocalizedString(self.titleForEmptyScreen, comment:"")
            #endif
            emptyview.titleLabel.text = titleForEmptyScreen
        }
    }
    @IBInspectable var descriptionForEmptyScreen:String = "Sorry, something is not right" {
        didSet {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                descriptionForEmptyScreen = bundle.localizedStringForKey(self.descriptionForEmptyScreen, value:"", table: nil)
            #else
                descriptionForEmptyScreen = NSLocalizedString(self.descriptionForEmptyScreen, comment:"");
            #endif
            emptyview.descriptionLabel.text = descriptionForEmptyScreen
        }
    }
    
    let activityIndicator = CustomActivityIndicator()
    
    lazy var emptyview:EmptyScreenView = EmptyScreenView(image: self.imageForEmptyScreen, title: self.titleForEmptyScreen, description: self.descriptionForEmptyScreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        debugPrint("RECEIVED MEMORY WARNING")
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        view.endEditing(true)
    }
    
    
    //MARK: Empty Screen Implementation
    func showEmptyScreen(belowSubview subview: UIView? = nil, superView:UIView? = nil) {
        let baseView: UIView = superView ?? self.view
        emptyview.frame = CGRectMake(0, 0, baseView.frame.width, baseView.frame.height)
        
        if let subview = subview {
            baseView.insertSubview(emptyview, belowSubview: subview)
        }
        else {
            baseView.addSubview(emptyview)
        }
    }
    
    func hideEmptyScreen() {
        emptyview.removeFromSuperview()
    }
    
    
    //MARK: - Alert/Error/Notification Implementation
    func showAlertWithMessage(message: String, title:String = "BYG", otherButtons:[String:((UIAlertAction)-> ())]? = nil, cancelTitle: String = "OK", cancelAction: ((UIAlertAction)-> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .Cancel, handler: cancelAction))
        
        if otherButtons != nil {
            for key in otherButtons!.keys {
                alert.addAction(UIAlertAction(title: key, style: .Default, handler: otherButtons![key]))
            }
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(error: NSError) {
        let alert = UIAlertController(title: error.domain, message: error.userInfo[kMessage] as? String ?? "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Show toast on click
    
    func showToastWithMessage(message: String) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
