//
//  questionLabel0.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/28/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class QuestionLabel0: UIView {
    
    var delegateViewController : QuestionViewController?
    
    var arr : [[[UInt16?]]] = Array(count: 3000, repeatedValue: Array(count : 3000, repeatedValue: Array(count: 4, repeatedValue: nil)))

    var view: UIView!
    
    var nibName: String = "QuestionLabel0"
    
    var class1AlreadySet = false
    
    var class2AlreadySet = false
    
    var variableValue: CGFloat = 0
    
    private var class1ID: String = ""
    
    private var class2ID: String = ""
    
    @IBOutlet weak var variableLabel: UILabel!

    @IBOutlet weak var class1Button: UIButton!
    
    @IBOutlet weak var class2Button: UIButton!
    
    @IBAction func class1ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 1")
    }
    
    @IBAction func class2ButtonPressed(sender: AnyObject) {
        delegateViewController!.animateContainerIn(sender as! UIButton, buttonType: "class 2")
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
                class1Button.setTitle(QuestionViewController.abreviateID(str!), forState: UIControlState.Normal)
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
        
        let answerArr = Array(arr[index1][index2][0...3])
        if (answerArr[0] != nil){
            let takenboth = Double(answerArr[1]!+answerArr[2]!+answerArr[3]!)
            let v1:CGFloat = CGFloat(takenboth * 100)/CGFloat(answerArr[0]!)
            let before:Double = Double(answerArr[1]!)*100/takenboth
            let concurrently:Double = Double(answerArr[2]!)*100/takenboth
            let after:Double = Double(answerArr[3]!)*100/takenboth
            param2 = [("Before", before),("During", concurrently),("After", after)]
            self.variable = v1
            
            print(String(v1) + "%")
            print(String(before) + "% " + String(concurrently) + "% " + String(after) + "%")
            
            
        } else {
            self.variable = 0
            param2 = [("Before", 0),("During", 0),("After", 0)]
        }
        
        
        
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
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
        
        //setupQuestionData()
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) {
            print("#1")
            
            
            var shorts = [UInt16]()
            if let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("A2_ConcurrentCourses", withExtension: "dat")!){
                var buffer = [UInt8](count: data.length, repeatedValue: 0)
                data.getBytes(&buffer, length: data.length)
                print("#2")
                
                for i in 0...buffer.count/2-1 {
                    let index = i*2
                    let bytes:[UInt8] = [buffer[index+1],buffer[index]]
                    let u16 = UnsafePointer<UInt16>(bytes).memory
                    shorts.append(u16)
                }
                print("#3")
                for i in 0...shorts.count/7-1{
                    let shortsSegment = Array(shorts[(i*7)...(6+i*7)])
                    assert(shortsSegment.count == 7, "not 7")
                    assert(shortsSegment[0] < 3000 && shortsSegment[1] < 3000, "wut")
                    self.arr[Int(shortsSegment[0])][Int(shortsSegment[1])][0] = shortsSegment[2]
                    self.arr[Int(shortsSegment[0])][Int(shortsSegment[1])][1] = shortsSegment[4]
                    self.arr[Int(shortsSegment[0])][Int(shortsSegment[1])][2] = shortsSegment[5]
                    self.arr[Int(shortsSegment[0])][Int(shortsSegment[1])][3] = shortsSegment[6]
                }
                
            }
            
            print("#4")
            
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            dispatch_async(mainQueue, {
                self.delegateViewController!.chart!.alpha = 1
                self.delegateViewController!.activityView.alpha = 0
                self.enableButtons(true)
                self.displayChartData()
            })
        }
    }
    
    
    
    func enableButtons(bool: Bool){
        self.class1Button.enabled = bool
        self.class2Button.enabled = bool
    }

}
 