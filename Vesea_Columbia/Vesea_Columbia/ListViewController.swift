//
//  ListViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/22/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import QuartzCore

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, ProblemFormDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var navigationBar: UINavigationBar!
    var delegate : ScrollViewController?
    
    var form : ProblemFormView?
    
    let cellHeight : CGFloat = 100
    
    var cellImages = Array(count: 7, repeatedValue: UIImage())
    
    func problemFormDidFinish(type: ProblemFormType) {
        if self.form!.type == .ListVC{
            UIView.animateWithDuration(0.2, animations: { 
                self.form!.alpha = 0
                self.form!.textView.resignFirstResponder()
                }, completion: { (true) in
                    self.form?.removeFromSuperview()
                    self.tableView.userInteractionEnabled = true
            })
        }
    }
    
    @IBAction func feedbackButtonPressed(sender: AnyObject) {
        form = ProblemFormView(frame: CGRect(x: 20, y: 80, width: self.view.frame.width-40, height: self.view.frame.height-310))
        form!.alpha = 0
        form!.delegate = self
        form!.type = .ListVC
        self.view.addSubview(form!)
        self.tableView.userInteractionEnabled = false
        self.form!.textView.becomeFirstResponder()
        UIView.animateWithDuration(0.2) { 
            self.form!.alpha = 1
        }
//        let v = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        self.view.insertSubview(v, atIndex: 999)
    }
    
    @IBAction func gearButtonPressed(sender: UIBarButtonItem) {
        self.delegate!.scrollView.setContentOffset(CGPointZero, animated: true)
        self.delegate!.scrollView.panGestureRecognizer.enabled = true
    }
        
    func waveCells(){
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            for i in 0...self.tableView.visibleCells.count-1 {
                NSThread.sleepForTimeInterval(0.15)
                let slidingDistance: CGFloat = 25
                let cell = self.tableView.cellForRowAtIndexPath((self.tableView.visibleCells[i] as! TableViewCell).indexPath)! as! TableViewCell
                    dispatch_async(dispatch_get_main_queue(), {
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            cell.slidingView.frame.origin.x = -slidingDistance
                            cell.slidingImageView?.frame.origin.x = slidingDistance
                            }, completion: { (true) in
                                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
                                    cell.slidingView.frame.origin.x = 0
                                    cell.slidingImageView?.frame.origin.x = 0
                                    }, completion: nil)
                        })
                })
            }
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        for i in 0...cellImages.count-1{
            cellImages[i] = self.imageForSection(i)
        }
        
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
        
        let navBarTopConstraint = NSLayoutConstraint(item: self.navigationBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        self.view.addConstraint(navBarTopConstraint)
        
        self.navigationBar.setBackgroundImage(UIImage(named: "Bar"), forBarMetrics: UIBarMetrics.Default)
        let navFont = UIFont(name: "Athelas", size: 30.0)
        let navBarAttributesDictionary: [String: AnyObject]? = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: navFont!
        ]
        self.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        self.navigationBar.layer.zPosition = 990
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panRecognizer)
        
        self.tableView.scrollsToTop = true
    }
    
    // MARK: - Tableview Datasource Methods
    
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
        
        let def = NSUserDefaults.standardUserDefaults()
        let course1ID : String = QuestionViewController.abreviateID(def.objectForKey("selectedCourse1") as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let course2ID : String = QuestionViewController.abreviateID(def.objectForKey("selectedCourse2") as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let course1Color = K.colors.course1Color
        let course2Color = K.colors.course2Color
        let majorColor = K.colors.majorColor

        let major : String = def.objectForKey("selectedMajor") as! String
        var myMutableString = NSMutableAttributedString()
        switch indexPath.section{
        case 0:
            myString = "Enrollment Trends for " + course1ID
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: course1Color, range: NSRange(location:22,length:course1ID.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:22,length:course1ID.characters.count))
            break
        case 1:
            myString = "Which majors typically take " + course1ID + "?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: course1Color, range: NSRange(location:28,length:course1ID.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:28,length:course1ID.characters.count))
            break;
        case 2:
            myString = "Do students who take " + course1ID + " also take " + course2ID + "?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: course1Color, range: NSRange(location:21,length:course1ID.characters.count))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: course2Color, range: NSRange(location:32 + course1ID.characters.count,length:course2ID.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:21,length:course1ID.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:32 + course1ID.characters.count,length:course2ID.characters.count))
            break;
        case 3:
            myString = "What other classes are taken along with " + course1ID
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: course1Color, range: NSRange(location:40,length:course1ID.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:40,length:course1ID.characters.count))
            break;
        case 4:
            myString = "What courses do " + major + " majors typically take and when?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: majorColor, range: NSRange(location:16,length:major.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:16,length:major.characters.count))
            break;
        case 5:
            myString = "How long does it take " + major + " majors to graduate?"
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 22.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: majorColor, range: NSRange(location:22,length:major.characters.count))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 22.0)!, range: NSRange(location:22,length:major.characters.count))
            break;
        default:
            break
        }
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        myMutableString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, myString.length))
        
        let slidingImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: cell.frame.size))
        slidingImageView.image = cellImages[indexPath.section]
        slidingImageView.contentMode = .ScaleAspectFill
        cell.slidingView.insertSubview(slidingImageView, belowSubview: cell.slidingViewLabel)
        cell.slidingImageView = slidingImageView
        
        cell.slidingViewLabel.attributedText = myMutableString
        cell.userInteractionEnabled = true
        
        cell.slidingView.clipsToBounds = true
        cell.iconView.image = UIImage(named: "graph_icon")
        cell.slidingView.backgroundColor = UIColor.blackColor()
        cell.originalSlidingViewOrigin = cell.slidingView.frame.origin

        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func imageForSection(section: Int) -> UIImage{
        
        let originalImage = UIImage(named: "citypic_filtered2")!
        let scaledImage = ListViewController.resizeImage(originalImage, newHeight: self.view.frame.height)
        let cgScaledImage = scaledImage.CGImage
        
        var maxNumberOfCells = 0
        while 130*(maxNumberOfCells+1) < Int(self.view.frame.height) {
            maxNumberOfCells += 1
        }
        
        let croppedImage = CGImageCreateWithImageInRect(cgScaledImage, CGRect(x: 0, y: self.cellHeight*CGFloat(section%maxNumberOfCells) + 30*CGFloat(section%maxNumberOfCells), width: self.view.frame.width+0.999, height: self.cellHeight))
        let result = UIImage(CGImage: croppedImage!)// ListViewController.addFilter(croppedImage!)
        
        return result
    }
    
    // MARK: - Tableview Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate!.resetQuestionViewController(indexPath.section)
        let nextPage = CGPoint(x: self.view.frame.width*2 + K.Others.screenGap*2, y: 0)
        delegate!.scrollView.setContentOffset(nextPage, animated: true)
        delegate!.scrollView.panGestureRecognizer.enabled = true
    }
    
    // MARK: - Class Functions
    
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
    
    // MARK: - Navigation Bar Setup
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    // MARK: - Pan Delegate method
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        let xVelocity = recognizer.velocityInView(self.view).x
        let viewWidth = self.view.frame.width
        let scrollToPrevPage = self.delegate!.scrollView.contentOffset.x < 0.55*viewWidth
        
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
                delegate!.scrollView.setHorizontalContentOffset(prevPage, velocity: recognizer.velocityInView(self.view))//setContentOffset(prevPage, animated: true)
                delegate!.scrollView.panGestureRecognizer.enabled = true
            } else {
                let thisPage = CGPoint(x: viewWidth + K.Others.screenGap, y: 0)
                delegate!.scrollView.setContentOffset(thisPage, animated: true)
            }
        }
    }
    
    
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
