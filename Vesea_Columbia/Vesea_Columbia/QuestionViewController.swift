//
//  QuestionViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/12/16.
//  Copyright © 2016 Lahav Opher Lipson. All rights reserved.
//

import UIKit
import Charts

class QuestionViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationBarDelegate {
    var chartType: String? = nil

    var questionLabel : UIView?
    
    var chooserBeingDisplayed = false
    
    var formatter = NSNumberFormatter()
    var titleText = String()
    var values = [(x: String, y: Double)]()
    
    var chart : UIView?

    var delegate : ScrollViewController? = nil
    
    var yConstraint = NSLayoutConstraint()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var graphBackground: UIView!
    @IBOutlet weak var graphBackgroundLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var graphBackgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var graphBackgroundWidth: NSLayoutConstraint!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        let menuPage = CGPoint(x: self.view.frame.width, y: 0)
        UIView.animateWithDuration(0.2, animations: {
            self.delegate?.scrollView.contentOffset = menuPage
        }) { (true) in
            self.delegate!.scrollView.panGestureRecognizer.enabled = false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImages()
        setupNavBar()
        navigationBar.delegate = self
        configureGraphBackground("")
        
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
        
        //Can be replaced or removed later
        
        let param1 = NSNumberFormatter()
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        let param2 = "Term"
        let param3 : [(x: String, y: Double)] = [("Spring 2015", 80),("Fall 2015", 100),("Spring2016", 70)]
        
        //customInitializer("Bar Chart", valueFormatter: param1, titleTxt: param2, xyValues: param3)
    }
    
    func customInitializer(chartKind: String, valueFormatter: NSNumberFormatter,titleTxt: String, xyValues: [(x: String, y: Double)]){
        
        if chart != nil{
            chart?.removeFromSuperview()
            chart = nil
        }
                
        formatter = valueFormatter
        titleText = titleTxt
        values = xyValues
        chartType = chartKind
        
        configureGraphBackground(titleText)
        
        let gBFrame = self.graphBackground.frame
        let frame = CGRect(origin: gBFrame.origin, size: CGSize(width: gBFrame.width, height: gBFrame.height-25))
        if chartType == "Horizontal Bar Chart"{
            chart = HorizontalBarChartView(frame: frame)
        } else if chartType == "Pie Chart"{
            chart = PieChartView(frame: frame)
        } else {
            chart = BarChartView(frame: frame)
        }
        
        //chart?.layer.masksToBounds = true
        
        var xValues = [String]()
        
        for i in 0...values.count-1{
            xValues.append(values[i].x)
        }
        
        var yValues = [BarChartDataEntry]()
        for i in 0...values.count-1{
            yValues.append(BarChartDataEntry(value: Double(values[i].y), xIndex: i))
        }
        
        switch self.chartType! {
        case "Horizontal Bar Chart":
            let dataSet = BarChartDataSet(yVals: yValues, label: "")
            dataSet.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]
            dataSet.valueFormatter = formatter
            dataSet.barSpace = 0.4
            let data = BarChartData(xVals: xValues, dataSet: dataSet)
            data.setDrawValues(false)
            let graph = (chart as! HorizontalBarChartView)
            graph.data = data
            graph.rightAxis.valueFormatter = formatter
            graph.rightAxis.valueFormatter?.minimumFractionDigits=0
            break
        case "Bar Chart":
            let dataSet = BarChartDataSet(yVals: yValues, label: "")
            dataSet.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]
            dataSet.valueFormatter = formatter
            dataSet.barSpace = 0.4
            let data = BarChartData(xVals: xValues, dataSet: dataSet)
            data.setDrawValues(false)
            let graph = (chart as! BarChartView)
            graph.data = data
            graph.leftAxis.valueFormatter = formatter
            graph.leftAxis.valueFormatter?.minimumFractionDigits=0
            break
        case "Pie Chart":
            let dataSet = PieChartDataSet(yVals: yValues, label: "")
            dataSet.colors = [
                UIColor(red: 66/255, green: 138/255, blue: 220/255, alpha: 0.7),
                UIColor(red: 112/255, green: 129/255, blue: 150/255, alpha: 0.7),
                UIColor(red: 48/255, green: 87/255, blue: 132/255, alpha: 0.7),
                UIColor(red: 139/255, green: 189/255, blue: 247/255, alpha: 0.7)
            ]
            dataSet.valueFormatter = formatter
            let data = PieChartData(xVals: xValues, dataSet: dataSet)
            data.setDrawValues(false)
            (chart as! PieChartView).data = data
            break
        default: break
        }

        configureChartSettings(chartType)

        self.view.addSubview(chart!)
        constrainChart()
        
        //Testing if I need this...
        
        if chartType == "Horizontal Bar Chart"{
            let graph = (chart as! HorizontalBarChartView)
            graph.notifyDataSetChanged()
        } else if chartType == "Pie Chart"{
            let graph = (chart as! PieChartView)
            graph.notifyDataSetChanged()
        } else {
            let graph = (chart as! BarChartView)
            graph.notifyDataSetChanged()
        }
        print("#2")
    }
    
    // MARK: - Chart Setup
    
    func constrainChart(){
        chart!.translatesAutoresizingMaskIntoConstraints = false
        var leftConstraint : NSLayoutConstraint?
        var rightConstraint : NSLayoutConstraint?
        var topConstraint : NSLayoutConstraint?
        var bottomConstraint : NSLayoutConstraint?
        
        switch self.chartType! {
        case "Bar Chart":
            leftConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            rightConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            topConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            bottomConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -25)
            break
        case "Horizontal Bar Chart":
            leftConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
            rightConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
            topConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            bottomConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -25)
            break
        case "Pie Chart":
            leftConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            rightConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            topConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            bottomConstraint = NSLayoutConstraint(item: self.chart!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphBackground, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            break
        default:
            break
        }
        
        self.view.addConstraints([leftConstraint!,rightConstraint!,topConstraint!,bottomConstraint!])
        chart?.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print(chart?.frame.height)
    }
    
    func configureChartSettings(type: String?){
        chart!.backgroundColor = UIColor.clearColor()
        //chart?.clipsToBounds = true
        
        if type == "Bar Chart"{
            let barChart = (chart as! BarChartView)
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
            barChart.scaleXEnabled = false
            barChart.scaleYEnabled = false
            barChart.rightAxis.enabled = false
            barChart.xAxis.drawLabelsEnabled = true
            barChart.leftAxis.drawLabelsEnabled = true
            barChart.xAxis.drawLabelsEnabled = true
            barChart.animate(yAxisDuration: 1.5, easingOption: .EaseOutQuart)
        } else if type == "Horizontal Bar Chart"{
            let hBarChart = (chart as! HorizontalBarChartView)
            hBarChart.drawGridBackgroundEnabled = false
            hBarChart.descriptionText = ""
            hBarChart.xAxis.labelPosition = .Bottom
            hBarChart.xAxis.labelTextColor = UIColor.whiteColor()
            hBarChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
            hBarChart.xAxis.setLabelsToSkip(0)
            hBarChart.xAxis.drawAxisLineEnabled = false//true
            hBarChart.xAxis.axisLineColor = UIColor.whiteColor()
            hBarChart.xAxis.drawGridLinesEnabled = false
            hBarChart.rightAxis.drawAxisLineEnabled = false
            hBarChart.rightAxis.axisMinValue = 0
            hBarChart.rightAxis.gridColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
            hBarChart.rightAxis.granularity = calcGranularity(hBarChart.leftAxis.axisMaxValue)
            hBarChart.rightAxis.drawGridLinesEnabled = true
            hBarChart.rightAxis.gridLineWidth = 2
            hBarChart.rightAxis.labelTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            hBarChart.rightAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
            hBarChart.legend.enabled = false
            hBarChart.scaleXEnabled = false
            hBarChart.scaleYEnabled = false
            hBarChart.rightAxis.enabled = true
            hBarChart.leftAxis.enabled = false
            hBarChart.xAxis.drawLabelsEnabled = true
            hBarChart.leftAxis.drawLabelsEnabled = true
            hBarChart.xAxis.drawLabelsEnabled = true
            hBarChart.animate(yAxisDuration: 1.5, easingOption: .EaseOutQuart)
        } else if type == "Pie Chart"{
            let pieChart = (chart as! PieChartView)
            pieChart.drawSliceTextEnabled = false
            pieChart.backgroundColor = UIColor.clearColor()
            pieChart.descriptionText = ""
            pieChart.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart
            pieChart.legend.yEntrySpace = 100
            pieChart.holeColor = UIColor.clearColor()
            pieChart.holeRadiusPercent = 0.50
            pieChart.animate(yAxisDuration: 1.5, easingOption:  .EaseOutQuart)
        }
    }
    
    // MARK: - Static Image Setup
    
    func setUpBackgroundImages(){
        let bottomBar = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.width, height: 60))
        bottomBar.image = UIImage(named: "bottombar")
        self.view.addSubview(bottomBar)
        
        let backGround = UIImageView(frame: self.view.frame)
        backGround.image = UIImage(named: "mountainbackground")
        self.view.addSubview(backGround)
        self.view.sendSubviewToBack(backGround)
    }
    
    func setupNavBar(){
        navigationBar.backgroundColor = K.colors.navBarColor
        backButton.tintColor = K.colors.lightBlack
    }
    
    func configureGraphBackground(titleText: String){
        graphBackground.layer.cornerRadius = 10
        graphBackground.layer.masksToBounds = true
        graphBackground.backgroundColor = K.colors.fadedGray
        graphBackgroundLabel.text = titleText
        graphBackgroundLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)!
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    // MARK: - Chooser
    
    func animateContainerIn(){
        chart?.userInteractionEnabled = false
        if !(self.chooserBeingDisplayed){
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.container.frame.origin.y = 100
                }, completion: { (true) in
                    self.chooserBeingDisplayed = true
                    self.yConstraint.constant = 500
            })
        }
    }
    
    func animateContainerOut(){
        chart?.userInteractionEnabled = true
        if (self.chooserBeingDisplayed){
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.container.frame.origin.y = -400
                }, completion: { (true) in
                    self.chooserBeingDisplayed = false
                    self.yConstraint.constant = 0
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
    
    func addLabel(preset: Int){
        
        if questionLabel != nil{
            questionLabel?.removeFromSuperview()
            questionLabel = nil
        }
        
        switch preset {
        case 0:
            questionLabel = QuestionLabel0(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
            (questionLabel as! QuestionLabel0).delegateViewController = self
            self.view.insertSubview(questionLabel!, belowSubview: container)
            questionLabel!.translatesAutoresizingMaskIntoConstraints = false
            let labelyConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: graphBackground, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -30)
            let labelWidthConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -60)
            let labelHeightConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
            let labelCenterXConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.view.addConstraints([labelWidthConstraint, labelCenterXConstraint, labelyConstraint, labelHeightConstraint])
            break
        case 1:
            questionLabel = QuestionLabel1(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
            (questionLabel as! QuestionLabel1).delegateViewController = self
            self.view.insertSubview(questionLabel!, belowSubview: container)
            questionLabel!.translatesAutoresizingMaskIntoConstraints = false
            let labelyConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: graphBackground, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -30)
            let labelWidthConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -60)
            let labelHeightConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 175)
            let labelCenterXConstraint = NSLayoutConstraint(item: questionLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.view.addConstraints([labelWidthConstraint, labelCenterXConstraint, labelyConstraint, labelHeightConstraint])
            break
        default:
            break
        }
    }
    
    // MARK: - Other
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if (segueName == "MajorChooser"){
            let destination = segue.destinationViewController as! MajorChooserViewController
            destination.delegateViewController = self
        }
    }
 

}
