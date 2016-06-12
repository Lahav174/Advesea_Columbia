//
//  TestGraphViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class TestGraphViewController: UIViewController, UIGestureRecognizerDelegate {

    
    func handleTap(recognizer: UITapGestureRecognizer){
        print("Tapped!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
