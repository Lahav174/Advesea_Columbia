//
//  QuestionLabel3.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/25/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class QuestionLabel3: UIView, SlidingSegmentedControlDelegate, QuestionLabel {

    var delegateViewController : QuestionViewController?
    
    var view: UIView!
    
    var nibName: String = "QuestionLabel3"
    
    private var classID: String = ""
    
    private var variableText: String = "concurrently"
    private var variableIndex: Int = 1
    
    var classAlreadySet = false
    
    @IBOutlet weak var variableLabel: UILabel!
    
    @IBOutlet weak var classButton: CourseButton!
    
    @IBAction func classButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 1")
    }
    
    var delegate : QuestionViewController {
        get {
            return delegateViewController!
        } set (value){
            delegateViewController = value
        }
    }
    
    @IBInspectable var class1 : String? {
        get{
            return classID
        } set (str){
            if str != nil && str! != classID{
                classID = str!
                //classButton.setTitle(QuestionViewController.abreviateID(str!), forState: UIControlState.Normal)
                classButton.idLabel.text = QuestionViewController.abreviateID(str!)
                if classAlreadySet{
                    displayChartData(variableIndex)
                }
                classAlreadySet = true
            }
        }
    }
    
    @IBInspectable var variable : String? {
        get{
            return variableText
        } set (value){
            if value != nil{
                variableText = String(value!)
                variableLabel.text = variableText + ":"
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
        
        classButton.setTitle("", forState: UIControlState.Normal)
        
        let delay = Int64(1.3*Double(NSEC_PER_SEC))
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            if self.delegateViewController?.questionNumber == 1{
                self.enableButtons(true)
                self.displayChartData(self.variableIndex)
            }
        }
    }
    
    func displayChartData(index: Int){
        var dataSet = [[UInt16?]]()
        switch index {
        case 0:
            dataSet = MyVariables.QuestionData.Q3_Before
            break
        case 1:
            dataSet = MyVariables.QuestionData.Q3_Concurrently
            break
        case 2:
            dataSet = MyVariables.QuestionData.Q3_After
            break
        default:
            break
        }
        let index = MyVariables.courses!.indexForKey(self.classID)
        let param1 = NSNumberFormatter()
        var param2 : [(x: String, y: Double)] = Array(count: 5, repeatedValue: ("",0))
        
        var answerArr : [UInt16?] = Array(dataSet[index])
        print("answerArr: " + String(answerArr))
        assert(answerArr.count == 11, "answerArr is not of length 11")
        if (answerArr[0] != nil){
            let total = Double(answerArr[0]!)/100.0
            for i in 0...4{
                assert(Int(answerArr[1 + i*2]!) != 0)
                let courseID = MyVariables.courses?.get(Int(answerArr[1 + i*2]!)-1)?.a! as! String
                let value = Double(answerArr[2*i+2]!)/total
                param2[4-i] = (courseID,value)
            }
            
        }
        
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        
        self.delegateViewController!.chart!.alpha = 1
        self.delegateViewController!.activityView.alpha = 0
        delegateViewController!.updateChartData(param1, xyValues: param2)
        
        
    }
    
    func enableButtons(bool: Bool){
        self.classButton.enabled = bool
    }
    
    func SlidingSegmentedControlDidSelectIndex(index: Int){
        self.variableIndex = index
        self.enableButtons(false)
        self.delegateViewController!.chart!.alpha = 0
        self.delegateViewController!.activityView.alpha = 1
        
        let delay = Int64(0.6*Double(NSEC_PER_SEC))
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
        switch index {
        case 0:
            self.variable = "beforehand"
            break
        case 1:
            self.variable = "concurrently"
            break
        case 2:
            self.variable = "afterwards"
            break
        default:
            break
        }
            self.enableButtons(true)
            self.delegateViewController!.chart!.alpha = 1
            self.delegateViewController!.activityView.alpha = 0
            self.displayChartData(self.variableIndex)
        }
    }
}
