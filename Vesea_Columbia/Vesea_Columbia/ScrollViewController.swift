//
//  ScrollViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/23/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

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
            questionViewController!.addLabel(0, frame: frame)
            break;
        case 1:
            height?.constant = 200
            param0 = "Horizontal Bar Chart"
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = "Term"
            param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            let frame = CGRect(x: 30, y: questionViewController!.graphBackground.frame.origin.y - questionViewController!.graphBackground.frame.height - 150, width: self.view.frame.width-30, height: 150)
            //questionViewController.addLabel(1, frame: frame)
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
            //questionViewController.addLabel(2, frame: frame)
            break;
        case 3:
            height?.constant = 200
            param0 = "Pie Chart"
            param1 = NSNumberFormatter()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = ""
            param3 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
            break;
        case 4:
            height?.constant = 200
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
        questionViewController?.chart?.layoutIfNeeded()
        questionViewController!.customInitializer(param0, valueFormatter: param1, titleTxt: param2, xyValues: param3)
    }
    
/*
    func rresetQuestionViewController(preset: Int){
        
        if (questionViewController != nil){
            questionViewController!.removeFromParentViewController()
            questionViewController!.view.removeFromSuperview()
        }
        
        
        switch preset {
        case 0, 2, 5:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("barchartvc") as! BarChartQuestionViewController
            newViewController.delegate = self
            setUpQuestionFrame(newViewController)
            var param1 = NSNumberFormatter()
            var param2 = String()
            var param3 = [(x: String, y: Double)]()
            if (preset == 0){
                param1 = NSNumberFormatter()
                param1.numberStyle = NSNumberFormatterStyle.PercentStyle
                param1.multiplier = 1
                param2 = "Term"
                param3 = [("Before", 80),("During", 100),("After", 70)]
                let frame = CGRect(x: 30, y: newViewController.barChart.frame.origin.y - newViewController.barChart.frame.height - 150, width: self.view.frame.width-30, height: 150)
                newViewController.addLabel(0, frame: frame)
                
            } else if (preset == 2){
                param1.numberStyle = NSNumberFormatterStyle.NoStyle
                param1.multiplier = 1
                param1.minimumFractionDigits = 0
                param2 = "Term"
                param3 = [("Spring 2015", 80),("Fall 2015", 100),("Spring 2016", 70)]
                let frame = CGRect(x: 30, y: newViewController.barChart.frame.origin.y - newViewController.barChart.frame.height - 150, width: self.view.frame.width-30, height: 70)
                newViewController.addLabel(2, frame: frame)
            } else if (preset == 5){
                param1.numberStyle = NSNumberFormatterStyle.PercentStyle
                param1.multiplier = 1
                param1.minimumFractionDigits = 0
                param2 = "Semester"
                param3 = [("6", 2),("7", 6),("8", 85),("9", 7)]
            }
            newViewController.customInitializer(param1,titleTxt: param2, xyValues: param3)
            questionViewController = newViewController
            break
        case 3:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("piechartvc") as! PieChartQuestionViewController
            setUpQuestionFrame(newViewController)
            let param1 = NSNumberFormatter()
            var param2 = [(x: String, y: Double)]()
            param1.numberStyle = NSNumberFormatterStyle.PercentStyle
            param1.multiplier = 1
            param2 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
            newViewController.customInitializer(param1, xyValues: param2)
            questionViewController = newViewController
            break
        case 1, 4:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("hbarchartvc") as! HBarChartQuestionViewController
            newViewController.delegate = self
            setUpQuestionFrame(newViewController)
            var param1 = NSNumberFormatter()
            var param2 = String()
            var param3 = [(x: String, y: Double)]()
            if (preset == 1){
                param1 = NSNumberFormatter()
                param1.numberStyle = NSNumberFormatterStyle.PercentStyle
                param1.multiplier = 1
                param2 = "Term"
                param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
                let frame = CGRect(x: 30, y: newViewController.hBarChart.frame.origin.y - newViewController.hBarChart.frame.height - 150, width: self.view.frame.width-30, height: 150)
                newViewController.addLabel(1, frame: frame)
            } else if (preset == 4){
                param1.numberStyle = NSNumberFormatterStyle.PercentStyle
                param1.multiplier = 1
                param1.minimumFractionDigits = 0
                param2 = "Term"
                param3 = [("W4323", 80),("W3211", 90),("1334", 70)]
            }
            newViewController.customInitializer(param1,titleTxt: param2, xyValues: param3)
            questionViewController = newViewController
            break;
        default:
            print("None")
        }
        
    }
  */
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
    
//      NOT GESTUREREC DELEGATE
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    func setUpMajors(){
        let def = NSUserDefaults.standardUserDefaults()
        let key = "majors"
        var majorArray = [NSDictionary]()
        
        if ((def.arrayForKey(key)) == nil){
            print("This array doesn't exist yet")
            for i in 0...99{
                let dict : NSDictionary = ["code":"E54123" + String(i),"name":"Computer Science" + String(i),"school":"Columbia College"]
                majorArray.insert(dict, atIndex: i)
            }
            def.setObject(majorArray, forKey: "majors")
        } else {
            print("This array exists now")
        }
        
        
        
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
    }
}
