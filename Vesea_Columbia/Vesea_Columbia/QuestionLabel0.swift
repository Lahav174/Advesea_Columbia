//
//  questionLabel0.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/28/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel0: UIView {
    
    var delegateViewController = QuestionViewController()

    var view: UIView!
    
    var nibName: String = "QuestionLabel0"
    
    var variableValue: Double = 0
    
    var class1Name: String = ""
    
    var class2Name: String = ""

    @IBOutlet weak var class1Button: UIButton!
    
    @IBOutlet weak var class2Button: UIButton!
    
    @IBAction func class1ButtonPressed(sender: AnyObject) {
        print("class1Button pressed")
        //delegateViewController.animateContainerIn()
    }
    
    @IBAction func class2ButtonPressed(sender: AnyObject) {
        print("class2Button pressed")
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
 