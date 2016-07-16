//
//  ProblemForm.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/15/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class ProblemFormView: UIView {
    
    var view: UIView!
    
    var nibName: String = "ProblemFormView"

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup(){
        
        view = loadViewFromNib()
        
        view.frame = bounds
        //view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
        
        //self.layer.cornerRadius = 15
        //self.layer.masksToBounds = true
        
        textView.indicatorStyle = .White
        
        stylizeFonts()
        
        let frame1 = CGRect(x: 0, y: self.frame.height-36, width: self.frame.width, height: 1)
        let hLine = UIView(frame: frame1)
        hLine.backgroundColor = UIColor(white: 151/255, alpha: 1)
        self.addSubview(hLine)
        
        let frame2 = CGRect(x: self.frame.width/2 - 0.5, y: self.frame.height-35, width: 1, height: 35)
        let vLine = UIView(frame: frame2)
        vLine.backgroundColor = UIColor(white: 151/255, alpha: 1)
        self.addSubview(vLine)
        
        print("width: " + String(self.frame.width))
    }
    
    func stylizeFonts(){
        let normalFont = UIFont(name: "HelveticaNeue", size: 16.0)
        
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: normalFont!
        ]
        
        segmentedControl.tintColor = UIColor(white: 133/255, alpha: 0.69)
        
        self.segmentedControl.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentedControl.setTitleTextAttributes(normalTextAttributes, forState: .Highlighted)
        self.segmentedControl.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
        let backgroundSegControl = UISegmentedControl(items: ["","",""])
        backgroundSegControl.frame = segmentedControl.frame
        backgroundSegControl.tintColor = UIColor(white: 151/255, alpha: 0.65)
        backgroundSegControl.userInteractionEnabled = false
        backgroundSegControl.selectedSegmentIndex = -1
        self.insertSubview(backgroundSegControl, aboveSubview: segmentedControl)
        
        backgroundSegControl.translatesAutoresizingMaskIntoConstraints = false
        
        let bsgConstTop = NSLayoutConstraint(item: backgroundSegControl, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: segmentedControl, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bsgConstLeading = NSLayoutConstraint(item: backgroundSegControl, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: segmentedControl, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let bsgConstTrailing = NSLayoutConstraint(item: backgroundSegControl, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: segmentedControl, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.addConstraints([bsgConstTop,bsgConstLeading,bsgConstTrailing])
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
