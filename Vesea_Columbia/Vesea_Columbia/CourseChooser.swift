//
//  CourseChooser.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/1/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseChooser: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var courses: [String] = ["Course 1", "Course 2", "Course 3"]
    
    var starred = [String]()
    
    var view: UIView!
    
    var nibName: String = "CourseChooser"
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return courses.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return starred.count
        } else if (section == 1){
            return courses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TableViewCell()//tableView.dequeueReusableCellWithIdentifier("theCell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = courses[indexPath.row]
        return cell
    }

}
