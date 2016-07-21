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
}

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    let someText = "hi there"
    
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
        
        self.scrollView.backgroundColor = UIColor.blackColor()
        
        self.scrollView.bounces = false
        
        checkForUpdate()
        
        setUpCourses()
                
        checkNewUser()
        
        scrollView.delaysContentTouches = false
                        
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 3 + K.Others.screenGap*2, self.view.frame.height);
        
        
        let vc0 = self.storyboard?.instantiateViewControllerWithIdentifier("frontvc") as! FrontViewController
        
        self.addChildViewController(vc0)
        self.scrollView.addSubview(vc0.view)
        vc0.didMoveToParentViewController(self)
        
        vc0.delegate = self
        
        
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
        
        let verticalConstraintVC1 = NSLayoutConstraint(item: vc1!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVC1)
        
        questionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chartquestionvc") as! QuestionViewController
        questionViewController!.delegate = self
        setUpQuestionFrame(questionViewController!)
        
    }
    
    func resetQuestionViewController(preset: Int){
        if (preset == self.indexOfActiveQuestion){
            return
        }
        self.indexOfActiveQuestion = preset
        
        questionViewController!.questionNumber = preset
        
        var param0 = String()
        var param1 = NSNumberFormatter()
        var param2 = String()
        var param3 = [(x: String, y: Double)]()
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
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = "Term"
            param3 = [("Before", 80),("During", 100),("After", 70)]
            break;
        case 1:
            height?.constant = 200
            yPos?.constant = 70
            param0 = "Horizontal Bar Chart"
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = "Term"
            param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            param4 = ["Before", "Concurrently", "After"]
            break;
        case 2:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Bar Chart"
            param1.numberStyle = NSNumberFormatterStyle.NoStyle
            param1.multiplier = 1
            param1.minimumFractionDigits = 0
            param2 = "Term"
            param3 = [("Spring 2015", 80),("Fall 2015", 100),("Spring 2016", 70)]
            break;
        case 3:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Pie Chart"
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = ""
            param3 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
            break;
        case 4:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Horizontal Bar Chart"
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param1.minimumFractionDigits = 0
            param2 = "Term"
            param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            break;
        case 5:
            height?.constant = 200
            yPos?.constant = 110
            param0 = "Bar Chart"
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param1.minimumFractionDigits = 0
            param2 = "Semester"
            param3 = [("6", 2),("7", 6),("8", 85),("9", 7)]
            break;
        default:
            break
        }
        questionViewController!.addLabel(preset)
        if preset < 40{
        questionViewController?.chart?.layoutIfNeeded()
        questionViewController!.customInitializer(param0, titleTxt: param2, tabLabels: param4)
        }
    }
    
    func setUpQuestionFrame(newViewController: UIViewController){
        
       // newViewController.view.frame.origin.x = self.view.frame.size.width*2
        
        self.addChildViewController(newViewController)
        self.scrollView.addSubview(newViewController.view)
        newViewController.didMoveToParentViewController(self)
        
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraintVCBAR = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: newViewController.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraintVCBAR)
        
        let heightConstraintVCBAR = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: newViewController.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraintVCBAR)
        
        let horizontalConstraintVCBAR = NSLayoutConstraint(item: newViewController.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.view.frame.size.width*2 + K.Others.screenGap*2)
        view.addConstraint(horizontalConstraintVCBAR)
        let verticalConstraintVCBAR = NSLayoutConstraint(item:  newViewController.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVCBAR)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == self.view.frame.width){
            scrollView.panGestureRecognizer.enabled = false
        }
    }
    
    func setUpCourses(){
        var courseDict = OrderedDictionary<NSDictionary>()
        var csvColumns = [String : [String]]()
        let coursesFile = "Courses"
        do {
            let csvURL = NSBundle(forClass: FrontViewController.self).URLForResource(coursesFile, withExtension: "csv")!
            //print("csvURL: " + String(csvURL))
            let csv = try CSV(url: csvURL)
            csvColumns = csv.columns
        } catch {
            print("Failed!")
            fatalError(coursesFile + ".csv could not be found")
        }
        for i in 0...csvColumns["Name"]!.count-1{
            let singleCourseDict : NSDictionary = ["Name":csvColumns["Name"]![i],
                                       "Credits":csvColumns["Credits"]![i],
                                       "Department":csvColumns["Department"]![i],
                                       "Culpa":csvColumns["Culpa"]![i]]
            courseDict.insert(singleCourseDict, forKey: csvColumns["ID"]![i], atIndex: i)
        }
        MyVariables.courses = courseDict
    }
    
    func checkNewUser(){
        let def = NSUserDefaults.standardUserDefaults()
        if def.objectForKey("Username") == nil{
            def.setObject(ScrollViewController.generateRandomID(8), forKey: "Username")
        }
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
        }
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
    }
}
