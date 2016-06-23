//
//  QuestionLabel2.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/30/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel2: UIView {

    var view: UIView!
    
    var nibName: String = "QuestionLabel2"
    
    var variable1Value: Double = 0
    
    var variable2Value: Double = 0
    
    var className: String = ""
    
    @IBOutlet weak var classButton: UIButton!
    
    @IBOutlet weak var variable1Label: UILabel!
    
    @IBOutlet weak var variable2Label: UILabel!
    
    @IBAction func classButtonPressed(sender: AnyObject) {
    }
    
    @IBInspectable var variable1 : Float? {
        get{
            return Float(variable1Value)
        } set (value){
            if value != nil{
                variable1Value = Double(value!)
            }
        }
    }
    
    @IBInspectable var variable2 : Float? {
        get{
            return Float(variable2Value)
        } set (value){
            if value != nil{
                variable2Value = Double(value!)
            }
        }
    }
    
    @IBInspectable var classID : String? {
        get{
            return className
        } set (str){
            if str != nil{
                className = str!
                classButton.titleLabel?.text = className
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
