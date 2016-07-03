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
        
        let originalImage = UIImage(named: "citypic")!
        let modifiedImage = resizeImage(originalImage, newHeight: self.view.frame.height)
        let newImage = modifiedImage.CGImage
        
        
        
        let croppedImage = CGImageCreateWithImageInRect(newImage, CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 200))
        
        let result = addFilter(croppedImage!)
        
        let v = UIImageView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        v.image = result
        self.view.addSubview(v)
        
        
    }
    
//    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
//        
//        let scale = newWidth / image.size.width
//        let newHeight = image.size.height * scale
//        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
//        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }


    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addFilter(picture: CGImage) -> UIImage{
        let beginImage = CIImage(CGImage: picture)
        let filter = CIFilter(name: "CISepiaTone")
        filter!.setValue(beginImage, forKey: kCIInputImageKey)
        filter!.setValue(0.5, forKey: kCIInputIntensityKey)
        return UIImage(CIImage: (filter?.outputImage)!)
    }
    
}
