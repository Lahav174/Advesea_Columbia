//
//  HBarChartQuestionViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/27/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class HBarChartQuestionViewController: UIViewController {

    @IBOutlet weak var hBarChart: HorizontalBarChartView!
    
    @IBOutlet weak var graphBackground: UIView!
    
    @IBOutlet weak var semesterTitle: UILabel!
    
    var questionLabel = UIView()
    
    var formatter = NSNumberFormatter()
    var titleText = String()
    var values = [(x: String, y: Double)]()
    var delegate = ScrollViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImages()

        let param1 = NSNumberFormatter()
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        let param2 = "Term"
        let param3 : [(x: String, y: Double)] = [("W2130", 80),("W4303", 100),("W1012", 70)]
        
        //customInitializer(param1,titleTxt: param2, xyValues: param3)
    }
    
    func customInitializer(valueFormatter: NSNumberFormatter,titleTxt: String, xyValues: [(x: String, y: Double)]){
        formatter = valueFormatter
        titleText = titleTxt
        values = xyValues
        
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
        hBarChart.data = data
        
        
        
        hBarChart.rightAxis.valueFormatter = formatter
        hBarChart.rightAxis.valueFormatter?.minimumFractionDigits=0
        
        
        configureChartSettings()
        
        configureGraphBackground(titleText)
    }
    
    func addLabel(preset: Int, frame: CGRect){
        switch preset {
        case 0:
            questionLabel = QuestionLabel0(frame: frame)
        case 1:
            questionLabel = QuestionLabel1(frame: frame)
        default:
            questionLabel = QuestionLabel0(frame: frame)
        }
        self.view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        let yConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: hBarChart, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -70)
        let widthConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -60)
        let centerXConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraints([yConstraint, centerXConstraint, widthConstraint])
    }
    
    func configureGraphBackground(titleText: String){
        graphBackground.layer.cornerRadius = 10
        graphBackground.layer.masksToBounds = true
        graphBackground.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        semesterTitle.text = titleText
        semesterTitle.font = UIFont(name: "HelveticaNeue-Light", size: 16)!
    }
    
    func configureChartSettings(){
        hBarChart.backgroundColor = UIColor.clearColor()
        
        hBarChart.pinchZoomEnabled = true
        hBarChart.doubleTapToZoomEnabled = true
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
        hBarChart.scaleXEnabled = true
        hBarChart.scaleYEnabled = true
        hBarChart.rightAxis.enabled = true
        hBarChart.leftAxis.enabled = false
        hBarChart.xAxis.drawLabelsEnabled = true
        hBarChart.leftAxis.drawLabelsEnabled = true
        hBarChart.xAxis.drawLabelsEnabled = true
        
        hBarChart.animate(yAxisDuration: 1.5, easingOption: .EaseOutQuart)
    }
    
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
    
    func setUpBackgroundImages(){
        let bottomBar = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.width, height: 60))
        bottomBar.image = UIImage(named: "bottombar")
        self.view.addSubview(bottomBar)
        
        let backGround = UIImageView(frame: self.view.frame)
        backGround.image = UIImage(named: "mountainbackground")
        self.view.addSubview(backGround)
        self.view.sendSubviewToBack(backGround)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
