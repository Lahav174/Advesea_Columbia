//
//  CourseChooserViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/5/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {
    
    var courseChooserType = ""
    
    var selectedCourseID : String?
    
    var unfilteredCourseIDs = NSMutableDictionary()
    var filteredCourseIDs = NSMutableDictionary()
    var departmentHeadersInOrder = [String]()
    
    var delegateViewController : QuestionViewController?
    
    var searching : Bool = false
    var shouldBeginEditing : Bool = true
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    // MARK: - Buttons
    
    @IBAction func removeButtonPressed(sender: AnyObject) {
            delegateViewController!.animateContainerOut()
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        searchBar.text = ""
        self.clearButton.hidden = true
        self.tableView.reloadData()
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        self.tableView.reloadData()
        self.clearButton.hidden = true
        self.searchBar.addTarget(self, action: #selector(self.textfieldtextDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        self.view.layer.masksToBounds = true
        let border = CALayer()
        border.backgroundColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: CGFloat(0.5))
        border.borderWidth = 0
        self.view.layer.addSublayer(border)
        
        for i in 0...MyVariables.courses!.count-1{
            let course = MyVariables.courses!.get(i)
            if let arr = self.unfilteredCourseIDs.valueForKey(course!.b!["Department"]! as! String){
                (arr as! NSMutableArray).addObject(course!.a! as String)
            } else {
                self.unfilteredCourseIDs.setValue(NSMutableArray.init(array: [course!.a! as String]), forKey: course!.b!["Department"]! as! String)
            }
        }
        self.departmentHeadersInOrder = self.unfilteredCourseIDs.allKeys as! [String]
        self.departmentHeadersInOrder.sortInPlace()
        self.departmentHeadersInOrder = self.departmentHeadersInOrder.filter{$0 != "Core"}
        self.departmentHeadersInOrder.insert("Core", atIndex: 0)
        //print(self.unfilteredCourseIDs["Electrical Engineering"]!)
        //print(self.departmentHeadersInOrder)
    }
    
    // MARK: - Other TableView Methods
    
    func loadSelectedCell(type: String){
        
        let def = NSUserDefaults.standardUserDefaults()
        
        if (type == "class 1"){
            self.selectedCourseID = def.objectForKey("selectedCourse1") as! String
        } else if (type == "class 2"){
            self.selectedCourseID = def.objectForKey("selectedCourse2") as! String
        }
        //print("Currently, the selectedCourseCall is " + self.selectedCourseCall!)
        
        self.tableView.reloadData()
    }
    
    func selectCellWithID(ID: String)
    {
        let def = NSUserDefaults.standardUserDefaults()
        
        if self.selectedCourseID != ID{
            selectedCourseID = ID
            if (self.courseChooserType == "class 1"){
                def.setObject(ID, forKey: "selectedCourse1")
            } else if (self.courseChooserType == "class 2"){
                def.setObject(ID, forKey: "selectedCourse2")
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + self.departmentHeadersInOrder.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        headerView.backgroundColor = UIColor.lightGrayColor()
        headerView.textAlignment = NSTextAlignment.Center
        headerView.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        
        if section == 0{
            headerView.text = "Favorites"
        } else {
            headerView.text = self.departmentHeadersInOrder[section-1]
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section > 0{
            if searching && searchBar.text != "" {
                let deptName = self.departmentHeadersInOrder[section-1]
                if filteredCourseIDs[deptName]?.count == 0{
                    return 0
                }
            }
        }
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            let def = NSUserDefaults.standardUserDefaults()
            let key = "favorites"
            
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                return favs.count
            } else {
                return 0
            }
        } else {
            let deptName = self.departmentHeadersInOrder[section-1]
            if searching && searchBar.text != ""{
                return (self.filteredCourseIDs[deptName]! as! [String]).count
            } else {
                return (self.unfilteredCourseIDs[deptName]! as! [String]).count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let def = NSUserDefaults.standardUserDefaults()
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        cell.delegateViewController = self
        cell.indexPath = indexPath
        if indexPath.section == 0 {
            let favs = def.arrayForKey("favorites")! as NSArray
            let favID = favs[indexPath.row] as! String
            let courseDict = MyVariables.courses?.get(favID)
            cell.mainLabel.text = courseDict!["Name"]! as! String
            cell.subLabel.text = favID
            cell.courseObject = ObjectTuple(first: favID, second: courseDict!)
            cell.setStarImage(true)
            //Selects the correct cells
            if (self.selectedCourseID == favID as! String){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
        } else {
            var courseID = String()
            let deptName = self.departmentHeadersInOrder[indexPath.section-1]
            if searching && searchBar.text != "" {
                courseID = (self.filteredCourseIDs[deptName]! as! [String])[indexPath.row]
                let courseDict = MyVariables.courses!.get(courseID)!
                cell.mainLabel.text = courseDict["Name"]! as! String
                cell.subLabel.text = courseID
                cell.courseObject = ObjectTuple(first: courseID, second: courseDict)
            } else {
                courseID = (self.unfilteredCourseIDs[deptName]! as! [String])[indexPath.row]
                let courseDict = MyVariables.courses!.get(courseID)!
                cell.mainLabel.text = courseDict["Name"]! as! String
                cell.subLabel.text = courseID
                cell.courseObject = ObjectTuple(first: courseID, second: courseDict)
                
            }

            //Selects the correct cells
            if (selectedCourseID == courseID){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey("favorites")) != nil){
                let favs = def.arrayForKey("favorites")! as NSArray
                cell.setStarImage(favs.containsObject(courseID))
            }
        }
        
        
        return cell
    }
    
    func updateSearchResults(){
        self.filteredCourseIDs.removeAllObjects()
        
        for key in self.unfilteredCourseIDs.allKeys{
            filteredCourseIDs.setValue(NSMutableArray(), forKey: key as! String)
        }
        
        let searchText = self.searchBar.text!
        
        let searchPredicate = NSPredicate(format: "SELF.Name CONTAINS[c] %@ OR SELF.ID CONTAINS[c] %@", searchText, searchText)
        
        for deptKey in unfilteredCourseIDs.allKeys{
            let unfilteredClassesForSingleDept = NSMutableArray()
            for courseID in unfilteredCourseIDs[deptKey as! String] as! [String]{
                let courseDict = MyVariables.courses!.get(courseID)!
                unfilteredClassesForSingleDept.addObject(["ID":courseID,"Name":courseDict["Name"]!])
            }
            let filteredClassesForSingleDept = unfilteredClassesForSingleDept.filteredArrayUsingPredicate(searchPredicate)
            for courseDict in filteredClassesForSingleDept{
                filteredCourseIDs[deptKey as! String]?.addObject((courseDict as! NSDictionary)["ID"])
            }
        }
        self.tableView.reloadData()
        
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textfieldtextDidChange(textField: UITextField){
        if !(searchBar.isFirstResponder()){
            shouldBeginEditing = false
        }
        //updateSearchResults()
        clearButton.hidden = (textField.text == "")
        updateSearchResults()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Gonna Resign #1")
        searchBar.resignFirstResponder()
        return false
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let boolToReturn = shouldBeginEditing
        shouldBeginEditing = true
        return boolToReturn
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searching = true
    }
    
    // MARK: - Nav Bar Delegate Methods
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Top
    }
    
    // MARK: - Scroll View Delegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Gonna Resign #2")
        searchBar.resignFirstResponder()
        //let contentOffset = self.tableView.contentOffset.y
        //let rowsInFirstSection =  CGFloat((self.tableView.numberOfRowsInSection(0))*44 + 25)
        //print("firstSectionVisible: " + String(contentOffset < rowsInFirstSection))
    }
    
    // MARK: - Other
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

