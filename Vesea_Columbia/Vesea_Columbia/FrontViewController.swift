//
//  FrontViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import SwiftCSV

class FrontViewController: UIViewController {

    var delegate : ScrollViewController?
    var yConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let csv = try CSV(name: "users.csv")
        } catch {
            // Catch errors or something
        }
        
    }
    
}
