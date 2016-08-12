//
//  ScrollViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/23/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts
import SwiftCSV

struct MyVariables {
    static var courses : OrderedDictionary<NSDictionary>?
    struct QuestionData {
        static var Q2 : [[[UInt16?]]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : (MyVariables.courses?.count)! + 100, repeatedValue: Array(count: 4, repeatedValue: nil)))
        static var Q0 : [[UInt16?]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : 10, repeatedValue: nil))
        static var Q3_Before : [[UInt16?]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : 11, repeatedValue: nil))
        static var Q3_Concurrently : [[UInt16?]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : 11, repeatedValue: nil))
        static var Q3_After : [[UInt16?]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : 11, repeatedValue: nil))
    }
}

class ScrollViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var vc1 : ListViewController?
    
    var indexOfActiveQuestion = -1
    
    //var questionViewController = QuestionViewController()//.init(nibName: nil, bundle: nil)
    
    var questionViewController : QuestionViewController? = nil
    
    var questionViewControllerConstraints = [NSLayoutConstraint]()
    
    var scrollView = ScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let size = CGSize(width: self.view.frame.width+K.Others.screenGap, height: self.view.frame.height)
        
        self.scrollView.frame = CGRect(origin: CGPointZero, size: size)
        
        self.view.addSubview(scrollView)
        
        let widthConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 5)
        //self.view.addConstraint(widthConstraint)
        
        self.scrollView.pagingEnabled = true
        self.scrollView.scrollsToTop = false
        self.scrollView.backgroundColor = UIColor.blackColor()
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        checkForUpdate()
        
//        print(MyVariables.QuestionData.Q3_Before[7][4])
//        print(MyVariables.QuestionData.Q3_Concurrently[7][4])
//        print(MyVariables.QuestionData.Q3_After[7][4])
        
        checkNewUser()
        
        scrollView.delaysContentTouches = false
                        
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 3 + K.Others.screenGap*2, self.view.frame.height);
        
        
        let vc0 = self.storyboard?.instantiateViewControllerWithIdentifier("vc0nav") as! UINavigationController
        
        vc0.delegate = self
        
        self.addChildViewController(vc0)
        self.scrollView.addSubview(vc0.view)
        vc0.didMoveToParentViewController(self)
        
        vc0.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraintVC0 = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: vc0.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraintVC0)
        
        let heightConstraintVC0 = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: vc0.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraintVC0)
        
        let horizontalConstraintVC0 = NSLayoutConstraint(item: vc0.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraintVC0)
        
        let verticalConstraintVC0 = NSLayoutConstraint(item: vc0.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVC0)
        
        
        vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("listvc") as! ListViewController
        
        var frame1 = vc1!.view.frame
        
        frame1.origin.x = self.view.frame.size.width
        vc1!.view.frame = frame1
        
        self.addChildViewController(vc1!)
        self.scrollView.addSubview(vc1!.view)
        vc1!.didMoveToParentViewController(self)
        vc1!.delegate = self
        
        vc1!.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraintVC1 = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: vc1!.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraintVC1)
        
        let heightConstraintVC1 = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: vc1!.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraintVC1)
        
        let horizontalConstraintVC1 = NSLayoutConstraint(item: vc1!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: vc0.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: K.Others.screenGap)
        view.addConstraint(horizontalConstraintVC1)
        
        let verticalConstraintVC1 = NSLayoutConstraint(item: vc1!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: vc0.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVC1)
        
        questionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chartquestionvc") as! QuestionViewController
        questionViewController!.delegate = self
        
        self.addChildViewController(questionViewController!)
        self.scrollView.addSubview(questionViewController!.view)
        questionViewController!.didMoveToParentViewController(self)
        
        questionViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraintVCBAR = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: questionViewController!.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraintVCBAR)
        
        let heightConstraintVCBAR = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: questionViewController!.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraintVCBAR)
        
        let horizontalConstraintVCBAR = NSLayoutConstraint(item: questionViewController!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.view.frame.size.width*2 + K.Others.screenGap*2)
        view.addConstraint(horizontalConstraintVCBAR)
        let verticalConstraintVCBAR = NSLayoutConstraint(item:  questionViewController!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVCBAR)
        
    }
    
    func resetQuestionViewController(preset: Int){
        if (preset == self.indexOfActiveQuestion){
            return
        }
        self.indexOfActiveQuestion = preset
        
        questionViewController!.questionNumber = preset
        
        var param0 = String()
        var param2 = String()
        var param4 : [String]? = nil
        
        var width = questionViewController?.graphBackgroundWidth
        var height = questionViewController?.graphBackgroundHeight
        var yPos = questionViewController?.graphBackgroundY
        width?.constant = questionViewController!.view.frame.width - 30
        
        switch preset {
        case 0:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Bar Chart"
            param2 = "Term"
            break;
        case 1:
            height?.constant = 200
            yPos?.constant = 70
            param0 = "Horizontal Bar Chart"
            param2 = "Term"
            break;
        case 2:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Bar Chart"
            param2 = "Semester"
            break;
        case 3:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Horizontal Bar Chart"
            param2 = ""
            param4 = ["Before", "Concurrently", "After"]
            break;
        case 4:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Pie Chart"
            //param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            //param1.multiplier = 1
            param2 = ""
            //param3 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
            break;
        case 5:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Bar Chart"

            param2 = "Semester"
            break;
        default:
            break
        }
        
        if preset < 40{
        questionViewController?.chart?.layoutIfNeeded()
        questionViewController!.customInitializer(param0, titleTxt: param2, tabLabels: param4)
        questionViewController!.addLabel(preset)
        }
    }
    
    // MARK: - ScrollView Delegate Methods
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == self.view.frame.width + K.Others.screenGap){
            scrollView.panGestureRecognizer.enabled = false
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        assert(vc1 != nil)
        if indexOfActiveQuestion >= 0{
           let cell = vc1!.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: indexOfActiveQuestion))! as! TableViewCell
            if cell.slidingView.frame.origin.x != 0 || cell.slidingImageView?.frame.origin.x != 0{
                cell.slidingView.frame.origin.x = 0
                cell.slidingImageView?.frame.origin.x = 0
            }
        }
    }
    
    // MARK: - Check Update/New User
    
    func checkNewUser(){
        let def = NSUserDefaults.standardUserDefaults()
        if def.objectForKey("Username") == nil{
            def.setObject(ScrollViewController.generateRandomID(8), forKey: "Username")
        }
    }
    
    func checkForUpdate(){ //Called only when update or first time (Not when load)
        let def = NSUserDefaults.standardUserDefaults()
        
        //Note: changing the format of "favorites" in nsuserdefaults will cause a crash because this if-statement will fail, simply because it already exists
        if (true){
        
            var favorites = NSMutableArray() //reset favorites MIGHT CHANGE
            let arrayToSet = favorites as NSArray
            def.setObject(arrayToSet, forKey: "favorites")
            
            let majorDefault = "Political Science"
            let course1IDDefault = "ECONW1105"
            let course2IDDefault = "HUMAW1121"
            def.setObject(majorDefault, forKey: "selectedMajor")
            def.setObject(course1IDDefault, forKey: "selectedCourse1")
            def.setObject(course2IDDefault, forKey: "selectedCourse2")
            def.setObject(true, forKey: "Automatic Searching")
        }
    }
    
    // MARK: - Setup Data

    func setUpCourses(){
        var courseDict = OrderedDictionary<NSDictionary>()
        let coursesFile = "CoursesDept"
        
        if let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("CoursesDept", withExtension: "dat")!){
            
            if let str = String(data: data, encoding: NSUTF8StringEncoding) {
                let arr = str.componentsSeparatedByString("#")
                
                for i in 0...arr.count-1{
                    let lineArr = (arr[i]).componentsSeparatedByString(",")
                    let singleCourseDict : NSDictionary = ["Name":lineArr[2],
                                                           "Credits":lineArr[1],
                                                           "Department":lineArr[3],
                                                           "Culpa":lineArr[4]]
                    courseDict.insert(singleCourseDict, forKey: lineArr[0], atIndex: i)
                    
                }
            } else {
                fatalError("Problem turning data into string")
            }
        } else {
            fatalError("Problem reading courses")
        }
        MyVariables.courses = courseDict
    }
    
    func setupQuestionData(questionNumber: Int){
        
        switch questionNumber {
        case 0:
            var shorts = [UInt16]()
            if let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("A0_WhenIsCourseTaken", withExtension: "dat")!){
                var buffer = [UInt8](count: data.length, repeatedValue: 0)
                data.getBytes(&buffer, length: data.length)
                l()
                for i in 0...buffer.count/2-1 {
                    let index = i*2
                    let bytes:[UInt8] = [buffer[index+1],buffer[index]]
                    let u16 = UnsafePointer<UInt16>(bytes).memory
                    shorts.append(u16)
                }
                l()
                for i in 0...shorts.count/12-1{
                    let shortsSegment = Array(shorts[(i*12)...(11+i*12)])
                    assert(shortsSegment.count == 12, "not 12")
                    for i in 0...9{
                         MyVariables.QuestionData.Q0[Int(shortsSegment[0])][i] = shortsSegment[i+1]
                    }
                }
                l()
            }
            break
        case 2:
            var shorts = [UInt16]()
            if let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("A2_ConcurrentCourses", withExtension: "dat")!){
                var buffer = [UInt8](count: data.length, repeatedValue: 0)
                data.getBytes(&buffer, length: data.length)
                l()
                for i in 0...buffer.count/2-1 {
                    let index = i*2
                    let bytes:[UInt8] = [buffer[index+1],buffer[index]]
                    let u16 = UnsafePointer<UInt16>(bytes).memory
                    shorts.append(u16)
                }
                l()
                for i in 0...shorts.count/7-1{
                    let shortsSegment = Array(shorts[(i*7)...(6+i*7)])
                    assert(shortsSegment.count == 7, "not 7")
                    assert(shortsSegment[0] < 3000 && shortsSegment[1] < 3000, "wut")
                    MyVariables.QuestionData.Q2[Int(shortsSegment[0])][Int(shortsSegment[1])][0] = shortsSegment[2]
                    MyVariables.QuestionData.Q2[Int(shortsSegment[0])][Int(shortsSegment[1])][1] = shortsSegment[4]
                    MyVariables.QuestionData.Q2[Int(shortsSegment[0])][Int(shortsSegment[1])][2] = shortsSegment[5]
                    MyVariables.QuestionData.Q2[Int(shortsSegment[0])][Int(shortsSegment[1])][3] = shortsSegment[6]
                }
                l()
            }
            break
        case 3:
            for i in 1...3{
                var arr = [[UInt16?]]()
                var fileName = String()
                switch i {
                case 1:
                    arr = MyVariables.QuestionData.Q3_Before
                    fileName = "A3_AlsoTakenBefore"
                    break
                case 2:
                    arr = MyVariables.QuestionData.Q3_Concurrently
                    fileName = "A3_AlsoTakenConcurrently"
                    break
                case 3:
                    arr = MyVariables.QuestionData.Q3_After
                    fileName = "A3_AlsoTakenAfter"
                    break
                default:
                    break
                }
                var shorts = [UInt16]()
                if let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource(fileName, withExtension: "dat")!){
                    var buffer = [UInt8](count: data.length, repeatedValue: 0)
                    data.getBytes(&buffer, length: data.length)
                    l()
                    for i in 0...buffer.count/2-1 {
                        let index = i*2
                        let bytes:[UInt8] = [buffer[index+1],buffer[index]]
                        let u16 = UnsafePointer<UInt16>(bytes).memory
                        shorts.append(u16)
                    }
                    l()
                    for i in 0...shorts.count/12-1{
                        let shortsSegment = Array(shorts[(i*12)...(11+i*12)])
                        assert(shortsSegment.count == 12, "not 12")
                        for i in 0...10{
                            arr[Int(shortsSegment[0])][i] = shortsSegment[i+1]
                        }
                    }
                    l()
                }
                switch i {
                case 1:
                    MyVariables.QuestionData.Q3_Before = arr
                    break
                case 2:
                    MyVariables.QuestionData.Q3_Concurrently = arr
                    break
                case 3:
                    MyVariables.QuestionData.Q3_After = arr
                    break
                default:
                    break
                }
            }
            
            break
        default:
            break
        }
        
    }
    
    // MARK: - Navigation Controller Delegate Methods
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if viewController.isKindOfClass(FrontViewController){
            print("To Front view")
            self.scrollView.scrollEnabled = true
        } else if viewController.isKindOfClass(SettingsTableViewController){
            print("To settings")
            self.scrollView.scrollEnabled = false
        }
    }
    
    // MARK: - Other
    
    func l(){
        self.appDelegate.loadingProgress += 1
    }
    
    class func generateRandomID(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890".characters.map { String($0) }
        var id = ""
        for _ in 1...length{
            id += characters[Int(arc4random_uniform(62))]
        }
        print(id)
        return id
    }
}

struct K {
    struct Others {
        static let screenGap: CGFloat = 1
    }
    
    struct colors {
        static let fadedGray = UIColor(white: 0.6, alpha: 0.5)//(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        static let lightBlack = UIColor(white: 42/255, alpha: 1)
        static let navBarColor = UIColor(red: 185/255, green: 205/255, blue: 227/255, alpha: 1)
        static let tableviewBackgroundColor = UIColor(red: 140/255, green: 144/255, blue: 178/255, alpha: 1)
        static let segmentedControlBackgroundColor = UIColor(red: 158/255, green: 171/255, blue: 185/255, alpha: 0.77)
        static let majorColor = UIColor(red: 191/255, green: 56/255, blue: 26/255, alpha: 1)
        static let course1Color = UIColor(red: 233/255, green: 175/255, blue: 50/255, alpha: 1)
        static let course2Color = UIColor(red: 222/255, green: 116/255, blue: 42/255, alpha: 1)
        static let standardBlue = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    }
}
