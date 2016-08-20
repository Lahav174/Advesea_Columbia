//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class FrontViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    var delegate : ScrollViewController?
    
    var sizeThatFits = CGSize()
    
    var backgroundImageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstIntroTextView: UITextView!
    @IBOutlet weak var secondIntroTextView: UITextView!
    @IBOutlet weak var thirdIntroTextView: UITextView!
    
    @IBOutlet weak var firstIntroHeight: NSLayoutConstraint!
    @IBOutlet weak var secondIntroHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdIntroHeight: NSLayoutConstraint!
    
    @IBOutlet weak var whatIsFirstTextView: UITextView!
    @IBOutlet weak var whatisSecondTextView: UITextView!
    
    @IBOutlet weak var whatIsFirstHeight: NSLayoutConstraint!
    @IBOutlet weak var whatIsSecondHeight: NSLayoutConstraint!
    
    @IBOutlet weak var beforeYouGoTextView: UITextView!
    @IBOutlet weak var beforeYouGoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstTipsTextView: UITextView!
    @IBOutlet weak var secondTipsTextView: UITextView!
    
    @IBOutlet weak var firstTipsHeight: NSLayoutConstraint!
    @IBOutlet weak var secondTipsHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeThatFits = CGSize(width: self.view.frame.width - 60, height: 10000)
        //scrollView.contentSize.height = 1000
        scrollView.contentSize.width = self.view.frame.width
        scrollView.delegate = self
        
        backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.image = UIImage(named: "cloudsCropped")
        self.contentView.insertSubview(backgroundImageView, atIndex: 0)
        
        firstIntroTextView.text = "Choose from any one of the preset questions. Each question is modular, and contains one or more highlighted keywords, which can be altered."
        firstIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        firstIntroHeight.constant = firstIntroTextView.sizeThatFits(sizeThatFits).height
        
        secondIntroTextView.text = "To change a keyword, open a question and tap on the highlighted word. Then, choose a replacement from the drop down menu. Changing a keyword will also change every keyword of the same color."
        secondIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        secondIntroHeight.constant = secondIntroTextView.sizeThatFits(sizeThatFits).height
        
        thirdIntroTextView.text = "The questions can be altered to reflect any courses relevant to you. This will hopefully help  you in the course selection process."
        thirdIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        thirdIntroHeight.constant = thirdIntroTextView.sizeThatFits(sizeThatFits).height
        
        whatIsFirstTextView.text = "Choosing your course schedule can be stressful, despite the availability of teacher reviews and peer/administration suggestions."
        whatIsFirstTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        whatIsFirstHeight.constant = whatIsFirstTextView.sizeThatFits(sizeThatFits).height
        
        whatisSecondTextView.text = "Advesea examines the course enrollment history of students from the past 10 years and allows students to access information on what other students in similar situation are doing, and get their questions answered."
        whatisSecondTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        whatIsSecondHeight.constant = whatisSecondTextView.sizeThatFits(sizeThatFits).height
        
        beforeYouGoTextView.text = "Feel free to give feedback! Does Advesea crash sometimes? Is an animation broken? Any ideas on how we could improve the app? New ideas for questions?"
        beforeYouGoTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        beforeYouGoHeight.constant = beforeYouGoTextView.sizeThatFits(sizeThatFits).height
        
        firstTipsTextView.text = "Try searching for courses by ID, rather than by name. The courses you know might not be spelled exactly the same way on Advesea, but the ID will be identical. "
        firstTipsTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        firstTipsHeight.constant = firstTipsTextView.sizeThatFits(sizeThatFits).height
        
        secondTipsTextView.text = "Tap the star next to classes you are thinking about taking. This will make sure they are always at the top of the course menu, so you can always find them easily."
        secondTipsTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        secondTipsHeight.constant = secondTipsTextView.sizeThatFits(sizeThatFits).height
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        contentViewHeight.constant = secondTipsTextView.frame.maxY + 40
        contentView.layoutIfNeeded()
        
        print("second Tips height: \(secondTipsTextView.frame.maxY)")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        backgroundImageView.frame.origin.y = scrollView.contentOffset.y
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Settings", sender: self)
    }
    
    @IBAction func listButtonPressed(sender: AnyObject) {
        delegate!.scrollView.panGestureRecognizer.enabled = false
        delegate!.scrollView.setContentOffset(CGPoint(x: self.view.frame.width + K.Others.screenGap, y: 0), animated: true)
    }
    
    @IBAction func contactButtonPressed(sender: AnyObject) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["contact@advesea.com"])
        composeVC.setSubject("Contact Advesea")
        if MFMailComposeViewController.canSendMail() {
            print("Trying to send mail")
            self.presentViewController(composeVC, animated: true, completion: nil)
            //self.navigationController!.pushViewController(mailComposeViewController, animated: true)
        } else {
            print("Couldn't print")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result.rawValue == MFMailComposeResultSent.rawValue ||
            result.rawValue == MFMailComposeResultCancelled.rawValue ||
            result.rawValue == MFMailComposeResultSaved.rawValue {
            
        } else {

        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
