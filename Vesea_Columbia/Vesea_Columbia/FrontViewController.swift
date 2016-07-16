//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    var delegate : ScrollViewController?
    var yConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = CGRect(x: 30, y: 100, width: self.view.frame.width-60, height: 180)
        let v = ProblemFormView(frame: f)
        self.view.addSubview(v)
        
    }
    
}
