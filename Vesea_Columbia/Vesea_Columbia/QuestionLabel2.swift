//
//  QuestionLabel2.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/28/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel2: UIView, QuestionLabel {
    
    private var delegateViewController : QuestionViewController?
    
    //var arr : [[[UInt16?]]] = Array(count: (MyVariables.courses?.count)! + 100, repeatedValue: Array(count : (MyVariables.courses?.count)! + 100, repeatedValue: Array(count: 4, repeatedValue: nil)))

    var view: UIView!
    
    var nibName: String = "QuestionLabel2"
    
    var class1AlreadySet = false
    
    var class2AlreadySet = false
    
    var variableValue: CGFloat = 0
    
    private var class1ID: String = ""
    
    private var class2ID: String = ""
    
    @IBOutlet weak var variableLabel: UILabel!

    @IBOutlet weak var class1Button: CourseButton!
    
    @IBOutlet weak var class2Button: CourseButton!
    
    @IBAction func class1ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 1")
    }
    
    @IBAction func class2ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 2")
    }
    
    var delegate : QuestionViewController {
        get {
            return delegateViewController!
        } set (value){
            delegateViewController = value
        }
    }
    
    @IBInspectable var variable : CGFloat? {
        get{
            return CGFloat(variableValue)
        } set (value){
            if value != nil{
                variableValue = CGFloat(value!)
                variableLabel.text = String(Int(value!)) + "%"
            }
        }
    }
    
    @IBInspectable var class1 : String? {
        get{
            return class1ID
        } set (str){
            if str != nil && str! != class1ID{
                class1ID = str!
                //class1Button.setTitle(QuestionViewController.abreviateID(str!), forState: UIControlState.Normal)
                class1Button.idLabel.text = QuestionViewController.abreviateID(str!)
                if class1AlreadySet{
                    displayChartData()
                }
                class1AlreadySet = true
            }
        }
    }
    
    @IBInspectable var class2 : String? {
        get{
            return class2ID
        } set (str){
            if str != nil && str! != class1ID{
                class2ID = str!
                class2Button.setTitle(QuestionViewController.abreviateID(str!), forState: UIControlState.Normal)
                class2Button.idLabel.text = QuestionViewController.abreviateID(str!)
                if class2AlreadySet{
                    displayChartData()
                }
                class2AlreadySet = true
            }
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func displayChartData(){
        let index1 = MyVariables.courses!.indexForKey(self.class1ID)
        let index2 = MyVariables.courses!.indexForKey(self.class2ID)
        let param1 = NSNumberFormatter()
        var param2 = [(x: String, y: Double)]()
        
        let answerArr = Array(MyVariables.QuestionData.Q2[index1][index2][0...3])
        if (answerArr[0] != nil){
            let takenboth = Double(answerArr[1]!+answerArr[2]!+answerArr[3]!)
            let v1:CGFloat = CGFloat(takenboth * 100)/CGFloat(answerArr[0]!)
            let before:Double = Double(answerArr[1]!)*100/takenboth
            let concurrently:Double = Double(answerArr[2]!)*100/takenboth
            let after:Double = Double(answerArr[3]!)*100/takenboth
            param2 = [("Before", before),("During", concurrently),("After", after)]
            self.variable = v1
            
            
        } else {
            self.variable = 0
            param2 = [("Before", 0),("During", 0),("After", 0)]
        }
        
        
        
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        
        self.delegateViewController!.chart!.alpha = 1
        self.delegateViewController!.activityView.alpha = 0
        delegateViewController!.updateChartData(param1, xyValues: param2)
        
        
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
        self.class2 = def.objectForKey("selectedCourse2") as! String
        
        enableButtons(false)
        class1Button.setTitle("", forState: UIControlState.Normal)
        class2Button.setTitle("", forState: UIControlState.Normal)
        
        let delay = Int64(1.3*Double(NSEC_PER_SEC))
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            if self.delegateViewController?.questionNumber == 2{
                self.delegateViewController!.chart!.alpha = 1
                self.delegateViewController!.activityView.alpha = 0
                self.enableButtons(true)
                self.displayChartData()
            }
            
        }
        
        
    }
    
    
    
    func enableButtons(bool: Bool){
        self.class1Button.enabled = bool
        self.class2Button.enabled = bool
    }
    
}
 