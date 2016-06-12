//
//  MajorChooser.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/2/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class MajorChooser: UIView, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var starred = [String]()

    var courses: [String] = ["Course 1", "Course 2", "Course 3"]
    var filteredCourses = [String]()
    var resultSearchController = UISearchController()
    
    var view: UIView!
    
    var nibName: String = "MajorChooser"
    
    
    
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
        
        
        //may need to change
        resultSearchController = UISearchController(searchResultsController: nil)//nibName: nibName, bundle: NSBundle(forClass: self.dynamicType))
        resultSearchController.searchResultsUpdater = self
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        var mySearchBar = UISearchBar(frame: frame)
        
        
        
        mySearchBar = resultSearchController.searchBar
        //mySearchBar.sizeToFit()
        
        self.view.addSubview(mySearchBar)
        
        mySearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let yConstraint = NSLayoutConstraint(item: mySearchBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: mySearchBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: mySearchBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraints([yConstraint, leftConstraint, rightConstraint])
    }
    
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredCourses.count
        } else {
            return courses.count
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "courses"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)//tableView.dequeueReusableCellWithIdentifier("theCell", forIndexPath: indexPath) as UITableViewCell
        
        if resultSearchController.active {
            cell.textLabel?.text = filteredCourses[indexPath.row]
        } else {
            cell.textLabel?.text = courses[indexPath.row]
        }
        
        
        cell.detailTextLabel?.text = "subtitle goes here"
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredCourses.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", resultSearchController.searchBar.text!)
        
        let array = (courses as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        filteredCourses = array as! [String]
        
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        resultSearchController.searchBar.text = searchText
    }
    
}
