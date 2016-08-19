//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Firebase

class FrontViewController: UIViewController {
    
    var textViewWidth = CGFloat()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var firstIntroTextView: UITextView!
    @IBOutlet weak var secondIntroTextView: UITextView!
    @IBOutlet weak var thirdIntroTextView: UITextView!
    
    @IBOutlet weak var firstIntroHeight: NSLayoutConstraint!
    @IBOutlet weak var secondIntroHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdIntroHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewWidth = self.view.frame.width - 60
        scrollView.contentSize.height = 1000
        scrollView.contentSize.width = self.view.frame.width
        
        firstIntroTextView.text = "Choose from any one of the preset questions. Each question is modular, and contains one or more highlighted keywords, which can be altered."
        firstIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        firstIntroHeight.constant = firstIntroTextView.sizeThatFits(CGSize(width: textViewWidth, height: 10000)).height
        
        secondIntroTextView.text = "To change a keyword, open a question and tap on the highlighted word. Then, choose a replacement from the drop down menu. Changing a keyword will also change every keyword of the same color."
        secondIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        secondIntroHeight.constant = secondIntroTextView.sizeThatFits(CGSize(width: textViewWidth, height: 10000)).height
        
        thirdIntroTextView.text = "The questions can be altered to reflect any courses relevant to you. This will hopefully help  you in the course selection process."
        thirdIntroTextView.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        thirdIntroHeight.constant = thirdIntroTextView.sizeThatFits(CGSize(width: textViewWidth, height: 10000)).height
        
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Settings", sender: self)
    }
    
}
