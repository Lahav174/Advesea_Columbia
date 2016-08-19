//
//  LaunchViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import UAProgressView

class LaunchViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var latestProgress = 0
    
    var timer = NSTimer()
    
    let pv = UAProgressView(frame: CGRect(x: 25, y: 100, width: 200, height: 200))
    let centerView = UILabel()

    func changeProgress(){
        
        if appDelegate.loadingProgress > self.latestProgress{
            latestProgress = appDelegate.loadingProgress
            pv.progress = (CGFloat(latestProgress)/15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pv.userInteractionEnabled = false
        pv.borderWidth = 3
        pv.lineWidth = 4
        pv.animationDuration = 1
        
        centerView.frame = CGRect(origin: CGPointZero
            , size: CGSize(width: 150, height: 100))
        centerView.text = "0%"
        centerView.textAlignment = .Center
        centerView.textColor = K.colors.standardBlue
        centerView.font = UIFont(name: "HelveticaNeue-Thin", size: 40)
        pv.centralView = centerView
        self.view.addSubview(pv)
        
        self.pv.progressChangedBlock = { v, p in
            self.centerView.text = String(Int(self.pv.progress*100)) + "%"
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.loadingProgress += 1
        
        self.pv.frame.origin = CGPoint(x: (self.view.frame.width-200)/2, y: (self.view.frame.height-200)/2)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("scroll") as! ScrollViewController
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(changeProgress), userInfo: nil, repeats: true)
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            
            vc.checkNewUser()
            vc.setUpCourses()
            for i in 0...6{
                vc.setupQuestionData(i)
            }
            vc.checkForUpdate()
 
            self.timer.invalidate()
            dispatch_async(dispatch_get_main_queue(), { 
                self.presentViewController(vc, animated: false, completion: nil)
            })
        }
        
    }

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