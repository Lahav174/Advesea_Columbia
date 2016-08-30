//
//  SettingsTableViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 8/8/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let def = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var automaticSearchingSwitch: UISwitch!
    
    @IBOutlet weak var backgroundFileUpdatingSwitch: UISwitch!

    @IBAction func automaticSearchingSwitched(sender: AnyObject) {
            def.setObject(!(def.objectForKey("Automatic Searching")! as! Bool), forKey: "Automatic Searching")
    }
    
    @IBAction func backgroundFileUpdatingSwitched(sender: AnyObject) {
        def.setObject(!(def.objectForKey("Automatic File Updating")! as! Bool), forKey: "Automatic File Updating")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticSearchingSwitch.setOn(def.objectForKey("Automatic Searching")! as! Bool, animated: false)
        
        backgroundFileUpdatingSwitch.setOn(def.objectForKey("Automatic File Updating")! as! Bool, animated: false)

    }
}
