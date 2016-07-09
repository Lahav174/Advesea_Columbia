//
//  QuestionLabel1.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/29/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel1: UIView {
    
    var delegateViewController : QuestionViewController?

    var view: UIView!
    
    var nibName: String = "QuestionLabel1"
    
    var variableValue: Double = 0
    
    var majorName: String = ""
    
    var class1Name: String = ""
    
    var class2Name: String = ""
    
    @IBOutlet weak var variableLabel: UILabel!

    @IBOutlet weak var majorButton: UIButton!
    
    @IBOutlet weak var class1Button: UIButton!
    
    @IBOutlet weak var class2Button: UIButton!
    
    @IBAction func majorButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func class1ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 1")
    }
    
    @IBAction func class2ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 2")
    }
    
    @IBInspectable var variable : Float? {
        get{
            return Float(variableValue)
        } set (value){
            if value != nil{
                variableValue = Double(value!)
            }
        }
    }
    
    @IBInspectable var class1 : String? {
        get{
            return class1Name
        } set (str){
            if str != nil{
                class1Name = str!
                class1Button.titleLabel?.text = class1Name
            }
        }
    }
    
    @IBInspectable var class2 : String? {
        get{
            return class2Name
        } set (str){
            if str != nil{
                class2Name = str!
                class2Button.titleLabel?.text = class2Name
            }
        }
    }
    
    @IBInspectable var major : String? {
        get{
            return majorName
        } set (str){
            if str != nil{
                majorName = str!
                majorButton.titleLabel?.text = majorName
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup(){
        
        view = loadViewFromNib()
        
        view.frame = bounds
        //view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    
}
