//
//  PieChartQuestionViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/20/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class PieChartQuestionViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var graphBackground: UIView!
    
    
    let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    var formatter = NSNumberFormatter()
    var values = [(x: String, y: Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let param2 : [(x: String, y: Double)] = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
//        
//        let param1 = NSNumberFormatter()
//        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
//        param1.multiplier = 1
//        param1.minimumFractionDigits = 0
//        
//        customInitializer(param1, xyValues: param2)
        
        var param1 = NSNumberFormatter()
        var param2 = [(x: String, y: Double)]()
        param1.numberStyle = NSNumberFormatterStyle.PercentStyle
        param1.multiplier = 1
        param2 = [("Computer Science", 40),("Mathematics", 30),("Physics", 20),("Other", 10)]
        customInitializer(param1, xyValues: param2)
        
    }
    
    func customInitializer(valueFormatter: NSNumberFormatter, xyValues: [(x: String, y: Double)]){
        formatter = valueFormatter
        values = xyValues
        
        setUpBackgroundImages()
        
        var xValues = [String]()
        
        for i in 0...values.count-1{
            xValues.append(values[i].x)
        }
        
        var yValues = [BarChartDataEntry]()
        for i in 0...values.count-1{
            yValues.append(BarChartDataEntry(value: Double(values[i].y), xIndex: i))
        }
        
        let dataSet = PieChartDataSet(yVals: yValues, label: "")
        dataSet.colors = [
            UIColor(red: 66/255, green: 138/255, blue: 220/255, alpha: 0.7),
            UIColor(red: 112/255, green: 129/255, blue: 150/255, alpha: 0.7),
            UIColor(red: 48/255, green: 87/255, blue: 132/255, alpha: 0.7),
            UIColor(red: 139/255, green: 189/255, blue: 247/255, alpha: 0.7)
        ]
        dataSet.valueFormatter = formatter
        let data = PieChartData(xVals: xValues, dataSet: dataSet)
        data.setDrawValues(true)
        pieChart.data = data
        
        configureChartSettings()
        
        configureGraphBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureChartSettings(){
        pieChart.drawSliceTextEnabled = false
        pieChart.backgroundColor = transparent
        pieChart.descriptionText = ""
        pieChart.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart
        pieChart.legend.yEntrySpace = 100
        pieChart.holeColor = transparent
        pieChart.holeRadiusPercent = 0.50
    }
    
    func configureGraphBackground(){
        graphBackground.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        graphBackground.layer.cornerRadius = 20
        graphBackground.layer.masksToBounds = true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
