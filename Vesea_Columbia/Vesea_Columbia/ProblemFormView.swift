//
//  ProblemForm.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/15/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Firebase

class ProblemFormView: UIView {
    
    var delegate : ProblemFormDelegate?
    
    var view: UIView!
    
    var type: ProblemFormType = .None
    
    var nibName: String = "ProblemFormView"
    
    var cancelButton = UIButton()
    
    var sendButton = UIButton()
    
    var courseID : String?
    
    let ref = FIRDatabase.database().reference()

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
    
    func reappearSetup(){
        self.segmentedControl.selectedSegmentIndex = 0
        self.textView.text = ""
    }
    
    func setup(){
        
        view = loadViewFromNib()
        
        view.frame = bounds
        //view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
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
        
        cancelButton.frame = CGRect(x: 0, y: self.frame.height-35, width: self.frame.width/2-0.5, height: 35)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(getImageWithColor(UIColor(white: 133/255, alpha: 0.69), size: cancelButton.frame.size), forState: UIControlState.Highlighted)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.Center
        cancelButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor(red: 1, green: 41/255, blue: 68/255, alpha: 1), forState: UIControlState.Highlighted)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton)
        
        sendButton.frame = CGRect(x: self.frame.width/2+0.5, y: self.frame.height-35, width: self.frame.width/2-0.5, height: 35)
        sendButton.setTitle("Send", forState: UIControlState.Normal)
        sendButton.setBackgroundImage(getImageWithColor(UIColor(white: 133/255, alpha: 0.69), size: cancelButton.frame.size), forState: UIControlState.Highlighted)
        sendButton.titleLabel?.textAlignment = NSTextAlignment.Center
        sendButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: UIControlState.Normal)
        sendButton.setTitleColor(UIColor(red: 49/255, green: 148/255, blue: 1, alpha: 1), forState: UIControlState.Highlighted)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), forControlEvents: .TouchUpInside)
        self.addSubview(sendButton)
                
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func cancelButtonPressed(sender: UIButton){
        print("Cancel Button Pressed")
//        if delegate is QuestionViewController{
//            let qvc = delegate as! QuestionViewController
//            qvc.flipInfoView("Problem")
//        }
        delegate?.problemFormDidFinish(self.type)
        
    }
    
    func sendButtonPressed(sender: UIButton){
        print("Send Button Pressed")
        
        var problemType = ""
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            problemType = "Other"
            break
        case 1:
            problemType = "Incorrect Info"
            break
        case 2:
            problemType = "Mislabeled"
            break
        default:
            break
        }
        
        var postTitle = String()
        let def = NSUserDefaults.standardUserDefaults()
        let probCountRef = ref.child("Problems").child("Course-Specific").child("Problem Count")
        probCountRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var newVal = String()
            if let val = snapshot.value as? String{
                newVal = String(Int(val)!+1)
            } else if let val = snapshot.value as? NSNumber{
                newVal = String(val.intValue + 1)
            }
            postTitle = newVal + " - " + def.stringForKey("Username")!
            probCountRef.setValue(newVal)
            
            let postRef = self.ref.child("Problems").child("Course-Specific").child(problemType).child(postTitle)
            
            let date = NSDate()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-dd-MM"
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss.S"
            
            if self.type == .Course{
                postRef.setValue(["Date":"Date","Course ID":self.courseID!,"Text":self.textView.text])
            } else {
                postRef.setValue(["Date":"Date","Text":self.textView.text])
            }
            postRef.child("Date").setValue(["Date":dateFormatter.stringFromDate(date),"Time":timeFormatter.stringFromDate(date)])
            
            
            self.textView.text = "Thank you"
            let delay = Int64(1*Double(NSEC_PER_SEC))
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.delegate?.problemFormDidFinish(self.type)
            }
            
            }, withCancelBlock: nil)
    }
    
    func stylizeFonts(){
        let normalFont = UIFont(name: "HelveticaNeue", size: 13.0)
        
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

protocol ProblemFormDelegate {
    func problemFormDidFinish(type: ProblemFormType)
}

enum ProblemFormType {
    case Course
    case QuestionVC
    case ListVC
    case None
}
