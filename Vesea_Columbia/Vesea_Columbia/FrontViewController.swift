//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    var delegate = ScrollViewController()
    var yConstraint = NSLayoutConstraint()
    
    //@IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
//        yConstraint = NSLayoutConstraint(item: self.container, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
//        self.view.addConstraint(yConstraint)
        //

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            //self.view.removeConstraint(self.yConstraint)
            
            //self.container.frame.origin.y = 10
            }, completion: nil)
        
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let position :CGPoint = touch.locationInView(view)
//            print(CGRectContainsPoint(self.container.frame, position))
//            
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
