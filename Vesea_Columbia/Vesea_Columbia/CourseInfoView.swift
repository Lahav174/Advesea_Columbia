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
    
    var courseID: String = ""
    
    var courseName: String = ""
    
    var courseDepartment: String = ""
    
    var courseDirectoryNumber: String = "123456"
    
    @IBOutlet weak var departmentLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var courseDirectoryNumLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func flipView(sender: UIButton) {
        delegate?.flipInfoView("Info")
    }
    
    @IBAction func openCulpa(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.reddit.com/")!)
    }
    
    @IBInspectable var ID : String {
        get{
            return courseID
        } set (id){
            courseID = id
            idLabel.text = id
            let courseDict = MyVariables.courses!.get(id)!
            courseName = courseDict["Name"] as! String
            nameLabel.text = courseName
            courseDepartment = courseDict["Department"] as! String
            let textRange = NSMakeRange(0, courseDepartment.characters.count)
            let attributedText = NSMutableAttributedString(string: courseDepartment)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
            departmentLabel.attributedText = attributedText
            courseDirectoryNumLabel.text = "Course Dir. #: " + courseDirectoryNumber
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
