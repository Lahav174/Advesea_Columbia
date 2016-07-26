//
//  LaunchViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var latestProgress = 0
    
    var timer = NSTimer()
    
    let imvLight = UIImageView(frame: CGRectZero)
    let imvDark = UIImageView(frame: CGRectZero)

    var cicleOrigin = CGPoint()

    func changeProgress(){
        
        if appDelegate.loadingProgress > self.latestProgress{
            latestProgress = appDelegate.loadingProgress
            print(String(Int(latestProgress*100/15)) + "%")
            shareImage(Int(latestProgress*100/15))
        }
    }
    
    func shareImage(darkFraction: Int){
        
        if darkFraction == 0{
            imvLight.frame = CGRect(origin: cicleOrigin, size: CGSize(width: 300, height: 300))
            let imageLight = ListViewController.resizeImage(UIImage(named: "Oval_light")!, newHeight: 300)
            imvLight.image = imageLight
            imvDark.image = nil
            return
        } else if darkFraction == 100{
            imvDark.frame = CGRect(origin: cicleOrigin, size: CGSize(width: 300, height: 300))
            let imageDark = ListViewController.resizeImage(UIImage(named: "Oval_dark")!, newHeight: 300)
            imvDark.image = imageDark
            imvLight.image = nil
            return

        }
        
        let darkFrac = Double(darkFraction)/100
        let lightFrac = 1 - darkFrac
        imvLight.frame = CGRect(origin: cicleOrigin, size: CGSize(width: 300, height: 300*lightFrac))
        let imageLight = ListViewController.resizeImage(UIImage(named: "Oval_light")!, newHeight: 300)
        let croppedLight = CGImageCreateWithImageInRect(imageLight.CGImage, CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 300*lightFrac)))
        imvLight.image = UIImage(CGImage: croppedLight!)
        
        imvDark.frame = CGRect(x: Double(cicleOrigin.x), y: Double(cicleOrigin.y) + 300*lightFrac, width: 300, height: 300*darkFrac)
        let imageDark = ListViewController.resizeImage(UIImage(named: "Oval_dark")!, newHeight: 300)
        let croppedDark = CGImageCreateWithImageInRect(imageDark.CGImage, CGRect(origin: CGPoint(x: 0, y: 300*lightFrac), size: CGSize(width: 300, height: 300*darkFrac)))
        imvDark.image = UIImage(CGImage: croppedDark!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cicleOrigin = CGPoint(x: self.view.frame.width/2-150, y: self.view.frame.height/2-150)
        
        self.view.addSubview(imvLight)
        self.view.addSubview(imvDark)
        imvLight.contentMode = .ScaleAspectFit
        imvDark.contentMode = .ScaleAspectFit
        shareImage(0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.loadingProgress += 1
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("scroll") as! ScrollViewController
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(changeProgress), userInfo: nil, repeats: true)
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            
            vc.setUpCourses()
            
            for i in 0...6{
                vc.setupQuestionData(i)
            }
            
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
