//
//  mainLabel.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/21/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class mainLabel: UIView {
    
    let majorColor = UIColor.redColor()
    let width : CGFloat = 330
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(labelNumber: Int, frame: CGRect, values: [String]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blueColor()
        switch labelNumber {
        case 1:
            createLabelOne(values)
            break;
        case 2:
            createLabelTwo()
            break;
        case 3:
            createLabelThree()
            break;
        case 4:
            createLabelFour()
            break;
        case 5:
            createLabelFive()
            break;
        case 6:
            createLabelSix()
            break;
        case 7:
            createLabelSeven()
            break;
        case 8:
            createLabelEight()
            break;
        case 9:
            createLabelNine()
            break;
        default:
            print("N/A")
        }
    }
    
    
    func createLabelOne(vals: [String]){
        let label1 = UILabel()
        label1.text = vals[0] + "% of students who took "
        let button1 = UIButton()
        button1.titleLabel?.text = vals[1]
        let label2 = UILabel()
        label2.text = " also took "
        let button2 = UIButton()
        button2.titleLabel?.text = vals[2]
        
        self.addSubview(label1)
        self.addSubview(button1)
        self.addSubview(label2)
        self.addSubview(button2)
        
        let constraint1 = NSLayoutConstraint(item: label1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4)
        let constraint2 = NSLayoutConstraint(item: label1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 4)
        
        self.addConstraints([constraint1,constraint2])
    }
    
    func createLabelTwo(){
        
    }
    
    func createLabelThree(){
        
    }
    
    func createLabelFour(){
        
    }
    
    func createLabelFive(){
        
    }
    
    func createLabelSix(){
        
    }
    
    func createLabelSeven(){
        
    }
    
    func createLabelEight(){
        
    }
    
    func createLabelNine(){
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
