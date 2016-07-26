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
    
    let imvLight = UIImageView(frame: CGRectZero)
    let imvDark = UIImageView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(imvLight)
        self.view.addSubview(imvDark)
        shareImage(60)
        
    }
    
    func shareImage(darkFraction: Int){
        let darkFrac = Double(darkFraction)/100
        let lightFrac = 1 - darkFrac
        imvLight.frame = CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 300*lightFrac))
        let imageLight = ListViewController.resizeImage(UIImage(named: "Oval_light")!, newHeight: 300)
        let croppedLight = CGImageCreateWithImageInRect(imageLight.CGImage, CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 300*lightFrac)))
        imvLight.image = UIImage(CGImage: croppedLight!)
        imvLight.contentMode = .ScaleAspectFit
        
        imvDark.frame = CGRect(x: 0, y: 300*lightFrac, width: 300, height: 300*darkFrac)
        let imageDark = ListViewController.resizeImage(UIImage(named: "Oval_dark")!, newHeight: 300)
        let croppedDark = CGImageCreateWithImageInRect(imageDark.CGImage, CGRect(origin: CGPoint(x: 0, y: 300*lightFrac), size: CGSize(width: 300, height: 300*darkFrac)))
        imvDark.image = UIImage(CGImage: croppedDark!)
        imvDark.contentMode = .ScaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
