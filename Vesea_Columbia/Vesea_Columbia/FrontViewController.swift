//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController, SlidingSegmentedControlDelegate {

    var delegate : ScrollViewController?
    var yConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slidingSeg = SlidingSegmentedControl(frame: CGRectMake(0, 100, 300, 50), buttonTitles: ["button1","buttttton2", "but23"])
        slidingSeg.delegate = self
        self.view.addSubview(slidingSeg)
        
    }
    
    func SlidingSegmentedControlDidSelectIndex(index: Int) {
        print("The sliding segmented control was selected at index " + String(index))
    }
    
}
