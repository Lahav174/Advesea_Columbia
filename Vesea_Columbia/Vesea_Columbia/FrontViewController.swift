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

    var delegate : ScrollViewController?
    var yConstraint = NSLayoutConstraint()
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref.child("Problems").child("Course-Specific").child("Other").child("POST").setValue("hi")
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print(MyVariables.courses!.indexForKey("COMSW3134"))
    }
    
    
}
