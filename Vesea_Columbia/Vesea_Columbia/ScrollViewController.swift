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

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: ScrollView!
    
    let someText = "hi there"
    
    //var questionViewController = QuestionViewController()//.init(nibName: nil, bundle: nil)
    
    var questionViewController : QuestionViewController? = nil
    
    var questionViewControllerConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMajors()
        
        scrollView.delaysContentTouches = false
                        
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 3, self.view.frame.height);
        
        
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
        
        
        let vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("listvc") as! ListViewController
        
        var frame1 = vc1.view.frame
        
        frame1.origin.x = self.view.frame.size.width
        vc1.view.frame = frame1
        
        self.addChildViewController(vc1)
        self.scrollView.addSubview(vc1.view)
        vc1.didMoveToParentViewController(self)
        vc1.delegate = self
        
        
        vc1.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraintVC1 = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: vc1.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraintVC1)
        
        let heightConstraintVC1 = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: vc1.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraintVC1)
        
        let horizontalConstraintVC1 = NSLayoutConstraint(item: vc1.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: vc0.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraintVC1)
        
        let verticalConstraintVC1 = NSLayoutConstraint(item: vc1.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVC1)
        
        questionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chartquestionvc") as! QuestionViewController
        questionViewController!.delegate = self
        setUpQuestionFrame(questionViewController!)
        
    }
    
    func resetQuestionViewController(preset: Int){
        print("GOT HERE BOIIIII")
        var param0 = String()
        var param1 = NSNumberFormatter()
        var param2 = String()
        var param3 = [(x: String, y: Double)]()
        var param4 : [String]? = nil
        
        var width = questionViewController?.graphBackgroundWidth
        var height = questionViewController?.graphBackgroundHeight
        width?.constant = questionViewController!.view.frame.width - 30
        
        switch preset {
        case 0:
            height?.constant = 200
            param0 = "Bar Chart"
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = "Term"
            param3 = [("Before", 80),("During", 100),("After", 70)]
            let frame = CGRect(x: 30, y: questionViewController!.graphBackground.frame.origin.y - questionViewController!.graphBackground.frame.height - 150, width: self.view.frame.width-30, height: 150)
            break;
        case 1:
            height?.constant = 200
            param0 = "Horizontal Bar Chart"
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = "Term"
            param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            param4 = ["Before", "Concurrently", "After"]
            let frame = CGRect(x: 30, y: questionViewController!.graphBackground.frame.origin.y - questionViewController!.graphBackground.frame.height - 150, width: self.view.frame.width-30, height: 150)
            break;
        case 2:
            height?.constant = 200
            param0 = "Bar Chart"
            param1.numberStyle = NSNumberFormatterStyle.NoStyle
            param1.multiplier = 1
            param1.minimumFractionDigits = 0
            param2 = "Term"
            param3 = [("Spring 2015", 80),("Fall 2015", 100),("Spring 2016", 70)]
            let frame = CGRect(x: 30, y: questionViewController!.graphBackground.frame.origin.y - questionViewController!.graphBackground.frame.height - 150, width: self.view.frame.width-30, height: 70)
            break;
        case 3:
            height?.constant = 200
            param0 = "Pie Chart"
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = ""
            param3 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
            break;
        case 4:
            height?.constant = 200
            param0 = "Horizontal Bar Chart"
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param1.minimumFractionDigits = 0
            param2 = "Term"
            param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            break;
        case 5:
            height?.constant = 200
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
        questionViewController!.customInitializer(param0, valueFormatter: param1, titleTxt: param2, xyValues: param3, tabLabels: param4)
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
        
        let horizontalConstraintVCBAR = NSLayoutConstraint(item: newViewController.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.view.frame.size.width*2)
        view.addConstraint(horizontalConstraintVCBAR)
        print(self.view.frame.size.width*2)
        let verticalConstraintVCBAR = NSLayoutConstraint(item:  newViewController.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintVCBAR)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print(scrollView.bounds.width/scrollView.contentSize.width)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == self.view.frame.width){
            scrollView.panGestureRecognizer.enabled = false
        }
    }
    
    func setUpMajors(){
        let def = NSUserDefaults.standardUserDefaults()
        let key = "majors"
        var majorArray = [NSDictionary]()
        
        //Note: changing the format of "favorites" in nsuserdefaults will cause a crash because this if-statement will fail, simply because it already exists
        if ((def.arrayForKey(key)) == nil){
            print("This array doesn't exist yet")
            
            var csvColumns = [String : [String]]()
            do {
                let csvURL = NSBundle(forClass: FrontViewController.self).URLForResource("Courses1", withExtension: "csv")!
                let csv = try CSV(url: csvURL)
                csvColumns = csv.columns
                //print(csv.columns["Name"]!)
            } catch {
                // Catch errors or something
                print("Failed!")
                fatalError("Courses1.csv could not be found")
            }
            print("csv collumn count: " + String(csvColumns.count))
            for i in 0...csvColumns["Name"]!.count-1{
                let dict : NSDictionary = ["Call":csvColumns["Call"]![i],"Name":csvColumns["Name"]![i],"ID": csvColumns["ID"]![i],"School":"Columbia College"]
                majorArray.insert(dict, atIndex: i)
            }
            
            def.setObject(majorArray, forKey: "majors")
            
            var favorites = NSMutableArray()
            let arrayToSet = favorites as NSArray
            def.setObject(arrayToSet, forKey: "favorites")
        } else {
            print("This array exists now")
        }
        print("#1")
        
        
//        if let defArray : AnyObject? = def.objectForKey(key) {
//            //majorArray = defArray! as! [NSDictionary]
//        } else {
//            print("This array doesn't exist yet")
//        }
        
        
    }

}

struct K {
    struct Others {
        static let Welcome = "kWelcomeNotif"
    }
    
    struct colors {
        static let fadedGray = UIColor(white: 0.6, alpha: 0.5)//(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        static let lightBlack = UIColor(white: 42/255, alpha: 1)
        static let navBarColor = UIColor(red: 185/255, green: 205/255, blue: 227/255, alpha: 1)
        static let tableviewBackgroundColor = UIColor(red: 140/255, green: 144/255, blue: 178/255, alpha: 1)
        static let segmentedControlBackgroundColor = UIColor(red: 158/255, green: 171/255, blue: 185/255, alpha: 0.77)
    }
}
