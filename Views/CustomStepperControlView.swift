//
//  CustomStepperControl.swift
//  BygApp
//
//  Created by Prince Agrawal on 21/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol StepperControlDelegate {
    func didChangeStepperControlForIndex(forIndex index:Int, selectedIndex: Int)
}

@IBDesignable class CustomStepperControl: UIView {
    @IBInspectable var minValue:Int = 0
    @IBInspectable var maxValue:Int = 3
    @IBInspectable var currentValue: Int = 0
    var index: Int!
    var setTitle = [String]()
    weak var delegate: StepperControlDelegate?
    @IBInspectable var thumbImage: UIImage?
    @IBInspectable var thumbBackgroundColor: UIColor = UIColor.blackColor() {
        didSet {
            thumbView?.backgroundColor = thumbBackgroundColor
        }
    }
    
    @IBInspectable var labelColor: UIColor = UIColor.blackColor() {
        didSet {
            for label in titleLabels ?? [UILabel]() {
                label.textColor = labelColor
            }
        }
    }
    
    @IBInspectable var segmentBackgroundColor: UIColor = UIColor.whiteColor() {
        didSet {
            for segView in segments ?? [UIButton]() {
                segView.backgroundColor = segmentBackgroundColor
            }
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.whiteColor() {
        didSet {
            trackView?.backgroundColor = selectedBackgroundColor
        }
    }



    
    private var thumbView: UIImageView?
    private var secondaryThumbView: UIImageView?
    private var trackView: UIView?
    private var segments:[UIButton]?
    private var titleLabels:[UILabel]?
    var tapGesture = UITapGestureRecognizer()
    
    
    
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //add tap gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapGesture(_:)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAppearence()
    }
    
    
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        let newFrame = CGRectInset(self.bounds, -40, -40)
//        return CGRectContainsPoint(newFrame, point) ? self : nil
//    }
    
    //MARK: Private Functions
    private func setupAppearence() {
        
        
        //setup thumbViews
        
        if(trackView == nil) {
            trackView = UIImageView()
            trackView!.userInteractionEnabled = true
            trackView!.clipsToBounds = true
            addSubview(trackView!)
        }
        trackView!.addGestureRecognizer(tapGesture)
        trackView!.clipsToBounds = false
        trackView!.layer.cornerRadius = trackView!.frame.height/2
        trackView!.frame = CGRectMake(trackView!.frame.height*2, frame.height/4, frame.width-(trackView!.frame.height*4), frame.height/8)
        trackView!.backgroundColor = selectedBackgroundColor
        
        //Setup Unslected view
        
        let segWidth = trackView!.frame.width/CGFloat(maxValue-minValue)

        if thumbView == nil {
            thumbView = UIImageView()
            thumbView!.backgroundColor = thumbBackgroundColor
            thumbView?.layer.shadowColor = UIColor.blackColor().CGColor
            thumbView?.layer.shadowOpacity = 0.5
            thumbView?.layer.shadowOffset = CGSizeMake((thumbView?.frame.height)!/2, (thumbView?.frame.height)!/2)
            thumbView!.clipsToBounds = false
            trackView!.addSubview(thumbView!)
        }
        
        thumbView?.userInteractionEnabled = true

        
        thumbView!.frame = CGRectMake(0, 0, trackView!.frame.height*4, trackView!.frame.height*4)
        
        thumbView!.center = CGPointMake(CGFloat(currentValue - minValue) * segWidth, trackView!.frame.height/2)
        thumbView!.layer.cornerRadius = trackView!.frame.height*2
        
        trackView!.bringSubviewToFront(thumbView!)

        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(CustomStepperControl.handlePanGesture(_:)))
        trackView!.addGestureRecognizer(panGesture)

        //setup Segments
        if segments == nil {
            segments = [UIButton]()
            titleLabels = [UILabel]()
            for index in minValue...maxValue {
                
                //Add Title
                let titleLabel = UILabel(frame: CGRectMake(0,0,trackView!.frame.width/(CGFloat(maxValue)),20))
                titleLabel.tag = index
                titleLabel.textColor = labelColor
                titleLabel.font = UIFont(name: "SFUIDisplay-Regular", size: 11)
                titleLabel.text = self.setTitle[index]
                titleLabel.numberOfLines=3
                if(Int(titleLabel.frame.size.width) >= Int((trackView!.frame.size.width))/maxValue-10) {
                    titleLabel.frame.size.width = CGFloat(Double((trackView!.frame.size.width))/(Double(maxValue)*1.3))
                }
                titleLabel.lineBreakMode = .ByWordWrapping
                titleLabel.sizeToFit()
                titleLabels!.append(titleLabel)
                addSubview(titleLabel)

                //Add Segment
                
                let segView = UIButton(frame: CGRectMake(0,0, trackView!.frame.height*2, trackView!.frame.height*2))
                segView.tag = index
                segView.addTarget(self, action: #selector(self.onSegmentTap(_:)), forControlEvents: .TouchUpInside)
                segView.backgroundColor = segmentBackgroundColor
                trackView!.addSubview(segView)
                trackView!.bringSubviewToFront(segView)
                segments!.append(segView)
            }
        }
        
        for index in 0 ..< segments!.count {
            
            segments![index].center = CGPointMake(CGFloat(segments![index].tag - minValue) * segWidth, trackView!.frame.height/2)
            segments![index].layer.cornerRadius = segments![index].frame.height/2
            trackView!.bringSubviewToFront(segments![index])
            if(index==(segments!.count)-1) {
                titleLabels![index].center = CGPointMake((CGFloat(titleLabels![index].tag) * trackView!.frame.width/(CGFloat(maxValue))-(titleLabels![index].frame.size.width/2))+CGFloat(titleLabels![index].frame.size.width/2) , frame.height)
            }
            else {
                titleLabels![index].center = CGPointMake((CGFloat(titleLabels![index].tag) * trackView!.frame.width/(CGFloat(maxValue))-8)+CGFloat(titleLabels![index].frame.size.width/2) , frame.height)
            }
        
        }
        
        trackView!.bringSubviewToFront(thumbView!)
    }
    
    @objc private func onSegmentTap(sender: UIButton) {
        currentValue = sender.tag
        setValue(forIndex: currentValue)
    }

    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.locationInView(trackView)
        print(translation)
        if(sender.state == .Changed) {
            let convertedPoint = trackView?.convertPoint(translation, fromView: self)
            if(convertedPoint!.x >= segments?.first?.frame.origin.x && convertedPoint!.x <= segments?.last?.frame.origin.x) {
                self.thumbView?.center.x = convertedPoint!.x
            }
        }
        
        if(sender.state == .Ended) {
            var segmentXValues = [CGFloat]()
            for index in 0 ..< segments!.count {
                segmentXValues.append(segments![index].center.x)
            }
            let DragValue = translation.x
            let closest = segmentXValues.enumerate().minElement( { abs($0.1 - DragValue) < abs($1.1 - DragValue)} )!
            setValue(forIndex: closest.index)
        }
    }
    
    @objc private func onTapGesture(sender: UITapGestureRecognizer?) {
        if let touchPoint = sender?.locationInView(self) {

            var currentIndex = Int()
            for index in 0 ..< segments!.count {
                if(index==segments!.count-1) {
                    currentIndex=index
                    break
                }
                else {
                    if(segments![index+1].center.x > touchPoint.x) {
                        if((touchPoint.x-segments![index].center.x) < (segments![index+1].center.x-touchPoint.x)) {
                            currentIndex=index
                            break
                            
                        }
                        else {
                            currentIndex=index+1
                            break
                        }
                    }
                }
                
            }
            setValue(forIndex: currentIndex)
            
        }
        
    }
    
    private func setValue(forIndex index: Int) {
        let segWidth = trackView!.frame.width/CGFloat(maxValue-minValue)
        UIView.animateWithDuration(0.3) {
            self.thumbView!.center = CGPointMake(CGFloat(index - self.minValue) * segWidth, self.trackView!.frame.height/2)
            self.trackView!.bringSubviewToFront(self.thumbView!)
            
        }
        delegate?.didChangeStepperControlForIndex(forIndex: self.index, selectedIndex: index)
    }
    
}
