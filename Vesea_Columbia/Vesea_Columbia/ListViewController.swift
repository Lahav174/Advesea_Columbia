//
//  ListViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/22/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var navigationBar: UINavigationBar!
    var delegate : ScrollViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = K.colors.tableviewBackgroundColor
        navigationBar.delegate = self
        
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        
        cell.slidingViewLabel.attributedText = myMutableString
        //cell.textLabel?.attributedText = myMutableString
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
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
    
    /*
     
     func handlePan(recognizer: UIPanGestureRecognizer){
     let xVelocity = recognizer.velocityInView(advesiaBackground).x
     let viewWidth = self.view.frame.width
     let scrollToPrevPage = self.delegate!.scrollView.contentOffset.x < 0.45*viewWidth
     
     if recognizer.state == .Began{
     
     }
     if recognizer.state == .Changed{
     let translation = recognizer.translationInView(advesiaBackground)
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
     */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
