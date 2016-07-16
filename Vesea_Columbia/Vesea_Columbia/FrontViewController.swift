//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    var delegate : ScrollViewController?
    var yConstraint = NSLayoutConstraint()
    
    var v1 : UIView!
    var v2 : UIView!
    var backgroundview : UIView!
    
    var displayingv1 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = CGRect(x: 10, y: 20, width: self.view.frame.width-20, height: 250)
        
        backgroundview = UIView(frame: f)
        self.view.addSubview(backgroundview)
        
        v1 = UIView(frame: CGRect(origin: CGPointZero, size: f.size))
        v1.backgroundColor = UIColor.blackColor()
        backgroundview.addSubview(v1)
        
        v2 = UIView(frame: CGRect(origin: CGPointZero, size: f.size))
        backgroundview.insertSubview(v2, belowSubview: v1)
        v2.backgroundColor = UIColor.whiteColor()
        
        
        
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        UIView.transitionFromView(v1, toView: v2, duration: 0.4, options: [UIViewAnimationOptions.TransitionFlipFromTop,UIViewAnimationOptions.CurveEaseInOut], completion: nil)
    }
    
    
}
