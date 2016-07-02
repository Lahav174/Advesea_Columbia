//
//  ListViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/22/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import QuartzCore

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var navigationBar: UINavigationBar!
    var delegate : ScrollViewController?
    
    let cellHeight : CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = K.colors.tableviewBackgroundColor
        navigationBar.delegate = self
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 20))
        headerView.backgroundColor = K.colors.tableviewBackgroundColor
        tableView.tableHeaderView = headerView
        
        self.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.navigationBar.layer.shadowOpacity = 0.5
        self.navigationBar.layer.shadowRadius = 4
        self.navigationBar.layer.shadowOffset = CGSizeMake(0, 10)
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shouldRasterize = true
        
        self.navigationBar.layer.zPosition = 999
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(panRecognizer)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIImageView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        headerView.image = UIImage(named: "shadow_rect")
        headerView.contentMode = .ScaleToFill
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwipeCell", forIndexPath: indexPath) as! TableViewCell
        cell.delegateController = self
        cell.indexPath = indexPath
        var myString = NSString()
        cell.textLabel?.numberOfLines = 2
        let courseA : String = "W3134"
        let courseB : String = "W3203"
        let major : String = "Computer Science"
        var myMutableString = NSMutableAttributedString()
        switch indexPath.section{
        case 0:
             myString = "Do students who take " + courseA + " also take " + courseB + "?"
             myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
             myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:22,length:courseA.characters.count))
             myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSRange(location:33 + courseA.characters.count,length:courseB.characters.count))
            break;
        case 1:
            myString = "What other classes are taken along with " + courseA
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:40,length:courseA.characters.count))
            break;
        case 2:
            myString = "Enrollment Trends for " + courseA
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:22,length:courseA.characters.count))
            break;
        case 3:
            myString = "Which majors typically take " + courseA + "?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:28,length:courseA.characters.count))
            break;
        case 4:
            myString = "What courses do " + major + " majors typically take and when?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:16,length:major.characters.count))
            break;
        case 5:
            myString = "How long does it take " + major + " majors to graduate?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:32,length:major.characters.count))
            break;
        case 6:
            myString = "Have another question? Type it here and we'll try to add it."
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            break;
        default:
            break
        }
        
        let slidingImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: cell.frame.size))
        slidingImageView.image = self.imageForSection(indexPath.section)
        slidingImageView.contentMode = .ScaleAspectFill
        cell.slidingView.insertSubview(slidingImageView, belowSubview: cell.slidingViewLabel)
        
        cell.slidingViewLabel.attributedText = myMutableString
        cell.userInteractionEnabled = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate!.resetQuestionViewController(indexPath.section)
        let nextPage = CGPoint(x: self.view.frame.width*2, y: 0)
        delegate!.scrollView.setContentOffset(nextPage, animated: true)
        delegate!.scrollView.panGestureRecognizer.enabled = true
    }
    
    func imageForSection(section: Int) -> UIImage{
        let originalImage = UIImage(named: "citypic_filtered")!
        let scaledImage = ListViewController.resizeImage(originalImage, newHeight: self.view.frame.height)
        let cgScaledImage = scaledImage.CGImage
        
        
        
        let croppedImage = CGImageCreateWithImageInRect(cgScaledImage, CGRect(x: 0, y: self.cellHeight*CGFloat(section), width: self.view.frame.width+0.999, height: self.cellHeight))
        let result = UIImage(CGImage: croppedImage!)// ListViewController.addFilter(croppedImage!)
        
        return result
    }
    
    class func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func addFilter(picture: CGImage) -> UIImage{
        let imageToBlur = CIImage(CGImage: picture)
        var blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        blurfilter!.setValue(15, forKey: "inputRadius")
        var resultImage = blurfilter!.valueForKey("outputImage") as! CIImage
        var blurredImage = UIImage(CIImage: resultImage)
        return blurredImage
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        print("Panned!")
        let xVelocity = recognizer.velocityInView(self.view).x
        let viewWidth = self.view.frame.width
        let scrollToPrevPage = self.delegate!.scrollView.contentOffset.x < 0.45*viewWidth
        
        if recognizer.state == .Began{
            
        }
        if recognizer.state == .Changed{
            let translation = recognizer.translationInView(self.view)
            if (translation.x >= 0){
                delegate!.scrollView.contentOffset.x = viewWidth - translation.x
            } else {
                delegate!.scrollView.contentOffset.x = viewWidth
            }
        }
        if recognizer.state == .Ended{
            if (scrollToPrevPage || xVelocity > 500){
                let prevPage = CGPoint(x: 0, y: 0)
                delegate!.scrollView.setContentOffset(prevPage, animated: true)
                delegate!.scrollView.panGestureRecognizer.enabled = true
            } else {
                let thisPage = CGPoint(x: viewWidth, y: 0)
                delegate!.scrollView.setContentOffset(thisPage, animated: true)
            }
        }
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
