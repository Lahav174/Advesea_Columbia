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
        
        let slidingSeg = SlidingSegmentedControl(frame: CGRectMake(0, 100, 300, 50), buttonTitles: ["button1","buttttton2", "but3"])
        self.view.addSubview(slidingSeg)
        
    }
    
}
