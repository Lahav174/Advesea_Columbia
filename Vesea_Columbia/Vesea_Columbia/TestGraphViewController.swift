//
//  TestGraphViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class TestGraphViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            print("#1")
            NSThread.exit()
            print("#2")
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
