//
//  CourseInfoView.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/15/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

@IBDesignable class CourseInfoView: UIView {
    
    var delegate: QuestionViewController?
    
    var view: UIView!
    
    var nibName: String = "CourseInfoView"
    
    private var courseID: String = ""
    
    private var courseName: String = ""
    
    private var courseDepartment: String = ""
    
    private var culpaIndex: String = ""
    
    private var courseCredits: String = ""
    
    @IBOutlet weak var departmentLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var commonlyTakenLabel: UILabel!
    
    @IBOutlet weak var courseDirectoryNumLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var culpaButton: UIButton!
    
    @IBAction func flipView(sender: UIButton) {
        delegate?.flipInfoView("Info")
    }
    
    @IBAction func openCulpa(sender: AnyObject) {
        if culpaIndex != ""{
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.culpa.info/courses/" + culpaIndex)!)
        }
    }
    
    @IBInspectable var ID : String {
        get{
            return courseID
        } set (id){
            courseID = id
            idLabel.text = id
            let courseDict = MyVariables.courses!.get(id)!
            commonlyTakenLabel.hidden = Int(courseDict["Taken 2014"]! as! String) < 800
            courseName = courseDict["Name"] as! String
            nameLabel.text = courseName
            courseDepartment = courseDict["Department"] as! String
            let textRange = NSMakeRange(0, courseDepartment.characters.count)
            let attributedText = NSMutableAttributedString(string: courseDepartment)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
            departmentLabel.attributedText = attributedText
            self.courseCredits = "Credits: " + (courseDict["Credits"] as! String)
            courseDirectoryNumLabel.text = self.courseCredits
            culpaIndex = courseDict["Culpa"] as! String
            if culpaIndex == ""{
                culpaButton.hidden = true
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
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
