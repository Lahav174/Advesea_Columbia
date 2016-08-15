//
//  TestGraphViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts
import UAProgressView

class TestGraphViewController: UIViewController {
    
    let pv = UAProgressView(frame: CGRect(x: 25, y: 100, width: 200, height: 200))
    let centerView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        pv.borderWidth = 3
        pv.lineWidth = 4
        pv.animationDuration = 1
        
        centerView.frame = CGRect(origin: CGPointZero
            , size: CGSize(width: 150, height: 100))
        centerView.text = "0%"
        centerView.textAlignment = .Center
        centerView.textColor = K.colors.standardBlue
        centerView.font = UIFont(name: "HelveticaNeue-Thin", size: 40)
        pv.centralView = centerView
        self.view.addSubview(pv)
        
        
        //let _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.increment), userInfo: nil, repeats: true)
        
        self.pv.progressChangedBlock = { v, p in
            self.centerView.text = String(Int(self.pv.progress*100)) + "%"
        }
        
    }
    
    func increment(){
        pv.setProgress(pv.progress + 0.13, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
