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
            let csvURL = NSBundle(forClass: FrontViewController.self).URLForResource("Courses1", withExtension: "csv")!
            let csv = try CSV(url: csvURL)
            //print(csv.columns["Name"]!)
        } catch {
            // Catch errors or something
            print("Failed!")
        }
        
    }
    
}
