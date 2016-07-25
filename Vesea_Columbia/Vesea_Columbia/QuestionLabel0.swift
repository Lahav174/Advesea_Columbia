//
//  QuestionLabel0.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel0: UIView {
    
    var delegateViewController : QuestionViewController?
    
    //var arr : [[UInt16?]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : 10, repeatedValue: nil))
    
    var view: UIView!
    
    var nibName: String = "QuestionLabel0"
    
    private var variableValue: CGFloat = 0
    
    private var classID: String = ""
    
    var classAlreadySet = false
    
    @IBOutlet weak var variableLabel: UILabel!

    @IBOutlet weak var classButton: UIButton!
    
    @IBAction func classButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 1")
    }
    
    @IBInspectable var variable : CGFloat? {
        get{
            return CGFloat(variableValue)
        } set (value){
            if value != nil{
                variableValue = CGFloat(value!)
                let decimal = Int(value!*10)%10
                let str1 = String(Int(value!)) + "."
                let str2 = String(decimal) + "%"
                variableLabel.text = str1 + str2
            }
        }
    }
    
    @IBInspectable var class1 : String? {
        get{
            return classID
        } set (str){
            if str != nil && str! != classID{
                classID = str!
                classButton.setTitle(QuestionViewController.abreviateID(str!), forState: UIControlState.Normal)
                if classAlreadySet{
                    displayChartData()
                }
                classAlreadySet = true
            }
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
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
        let def = NSUserDefaults.standardUserDefaults()
        self.class1 = def.objectForKey("selectedCourse1") as! String
        self.enableButtons(false)
        
        
        
        let delay = Int64(1.3*Double(NSEC_PER_SEC))
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            if self.delegateViewController?.questionNumber == 0{
                self.delegateViewController!.chart!.alpha = 1
                self.delegateViewController!.activityView.alpha = 0
                self.enableButtons(true)
                self.displayChartData()
            }
        }
        
        
        
    }
    
    func displayChartData(){
        print(MyVariables.QuestionData.Q0[4][0...5])
        let index = MyVariables.courses!.indexForKey(self.classID)
        let param1 = NSNumberFormatter()
        var param2 : [(x: String, y: Double)] = Array(count: 9, repeatedValue: ("",-1))
        
        let answerArr : [UInt16?] = Array(MyVariables.QuestionData.Q0[index])
        if (answerArr[0] != nil){
            let sum:Double = Array(answerArr[1...9]).reduce(0, combine: {Double($0) + Double($1!)})
            for i in 1...9{
                let val = Double(answerArr[i]!)*100/sum
                param2[i-1] = (String(i),val)
            }
            
            self.variable = CGFloat(answerArr[0]!)/50 //5000 students overall?
        } else {
            self.variable = 0
            param2 = [("1",0),("2",0),("3",0),("4",0),("5",0),("6",0),("7",0),("8",0),("9",0)]
        }
        
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        
            delegateViewController!.updateChartData(param1, xyValues: param2)
        
    }
    
    func enableButtons(bool: Bool){
        self.classButton.enabled = bool
    }

}



















