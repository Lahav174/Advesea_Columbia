//
//  Question1ViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/17/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class BarChartQuestionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var semesterTitle: UILabel!
    
    @IBOutlet weak var graphBackground: UIView!
    
    @IBOutlet weak var container: UIView!
    
    var questionLabel = UIView()
    
    var chooserBeingDisplayed = false
    
    var formatter = NSNumberFormatter()
    var titleText = String()
    var values = [(x: String, y: Double)]()
    var delegate = ScrollViewController()
    
    var yConstraint = NSLayoutConstraint()
    
    func tapFound(event: UITapGestureRecognizer){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFound(_:)))
        self.view.addGestureRecognizer(tap)
        
        setUpBackgroundImages()
        
        self.container.layer.cornerRadius = 10;
        self.container.layer.masksToBounds = true;
        self.container.layer.zPosition = 500
        
        self.container.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 400)
        heightConstraint.identifier = "CONTAINER HEIGHT CONSTRAINT"
        yConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0) //500
        yConstraint.identifier = "CONTAINER Y CONSTRAINT"
        self.view.addConstraints([heightConstraint, yConstraint])
        self.container.layoutIfNeeded()
        
        let param1 = NSNumberFormatter()
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        let param2 = "Term"
        let param3 : [(x: String, y: Double)] = [("Spring 2015", 80),("Fall 2015", 100),("Spring2016", 70)]
        
        customInitializer(param1,titleTxt: param2, xyValues: param3)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(self.container.frame.origin.y)
        
    }
    
    func customInitializer(valueFormatter: NSNumberFormatter,titleTxt: String, xyValues: [(x: String, y: Double)]){
        
        formatter = valueFormatter
        titleText = titleTxt
        values = xyValues
        
        configureGraphBackground(titleText)
        
        var xValues = [String]()
        
        for i in 0...values.count-1{
            xValues.append(values[i].x)
        }

        var yValues = [BarChartDataEntry]()
        for i in 0...values.count-1{
            yValues.append(BarChartDataEntry(value: Double(values[i].y), xIndex: i))
        }
        
        let dataSet = BarChartDataSet(yVals: yValues, label: "")
        dataSet.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]
        dataSet.valueFormatter = formatter
        dataSet.barSpace = 0.4
        let data = BarChartData(xVals: xValues, dataSet: dataSet)
        data.setDrawValues(false)
        barChart.data = data
        
        barChart.leftAxis.valueFormatter = formatter
        barChart.leftAxis.valueFormatter?.minimumFractionDigits=0
        configureChartSettings()
    
        
    }
    
    func addLabel(preset: Int, frame: CGRect){
        switch preset {
        case 0:
            questionLabel = QuestionLabel0(frame: frame)
            (questionLabel as! QuestionLabel0).delegateViewController = self
        case 2:
            questionLabel = QuestionLabel2(frame: frame)
        default:
            questionLabel = QuestionLabel0(frame: frame)
        }
        //self.view.addSubview(questionLabel)
        self.view.insertSubview(questionLabel, belowSubview: container)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        let yConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: barChart, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -70)
        let widthConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -60)
        let heightConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        let centerXConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraints([yConstraint, centerXConstraint, widthConstraint, heightConstraint])
    }
    
    func animateContainerIn(){
        if !(self.chooserBeingDisplayed){
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.container.frame.origin.y = 100
                }, completion: { (true) in
                    self.chooserBeingDisplayed = true
            })
        }
        
        
    }
    
    func animateContainerOut(){
        if (self.chooserBeingDisplayed){
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.container.frame.origin.y = -400
                }, completion: { (true) in
                    self.chooserBeingDisplayed = false
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject! in touches {
            let touchLocation = touch.locationInView(self.view)
            print("Touched")
            if !(self.container.frame.contains(touchLocation)) && chooserBeingDisplayed && self.container.frame.origin.y == 100{
                animateContainerOut()
            }
            
        }
    }
    
    func configureGraphBackground(titleText: String){
        graphBackground.layer.cornerRadius = 10
        graphBackground.layer.masksToBounds = true
        graphBackground.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        semesterTitle.text = titleText
        semesterTitle.font = UIFont(name: "HelveticaNeue-Light", size: 16)!
    }
    
    func configureChartSettings(){
        barChart.backgroundColor = UIColor.clearColor()
        
        barChart.pinchZoomEnabled = true
        barChart.doubleTapToZoomEnabled = true
        barChart.drawGridBackgroundEnabled = false
        barChart.descriptionText = ""
        barChart.xAxis.labelPosition = .Bottom
        barChart.xAxis.labelTextColor = UIColor.whiteColor()
        barChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        barChart.xAxis.setLabelsToSkip(0)
        barChart.xAxis.drawAxisLineEnabled = false//true
        barChart.xAxis.axisLineColor = UIColor.whiteColor()
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.axisMinValue = 0
        barChart.leftAxis.gridColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        barChart.leftAxis.granularity = calcGranularity(barChart.leftAxis.axisMaxValue)
        barChart.leftAxis.drawGridLinesEnabled = true
        barChart.leftAxis.gridLineWidth = 2
        barChart.leftAxis.labelTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        barChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        barChart.legend.enabled = false
        barChart.scaleXEnabled = true
        barChart.scaleYEnabled = true
        barChart.rightAxis.enabled = false
        barChart.xAxis.drawLabelsEnabled = true
        barChart.leftAxis.drawLabelsEnabled = true
        barChart.xAxis.drawLabelsEnabled = true
        barChart.animate(yAxisDuration: 1.5, easingOption: .EaseOutQuart)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpBackgroundImages(){
        let bottomBar = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.width, height: 60))
        bottomBar.image = UIImage(named: "bottombar")
        self.view.addSubview(bottomBar)
        
        let backGround = UIImageView(frame: self.view.frame)
        backGround.image = UIImage(named: "mountainbackground")
        self.view.addSubview(backGround)
        self.view.sendSubviewToBack(backGround)
        print("All set up!")
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    
    func calcGranularity(max: Double) -> Double{
        let i = Int(max)
        if (i/20 > 4){
            return 20
        } else if (i/10 > 4){
            return 10
        } else {
            return 5
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if (segueName == "MajorChooser"){
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! MajorChooserViewController
            destination.delegateViewController = self
        }
    }
 

}


