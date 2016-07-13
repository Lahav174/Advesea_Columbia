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
    
    var unfilteredCourses = NSMutableDictionary()
    var filteredCourses = NSMutableDictionary()
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
            if let arr = self.unfilteredCourses.valueForKey(course!.b!["Department"]! as! String){
                (arr as! NSMutableArray).addObject(course!.a! as String)
            } else {
                self.unfilteredCourses.setValue(NSMutableArray.init(array: [course!.a! as String]), forKey: course!.b!["Department"]! as! String)
            }
        }
        self.departmentHeadersInOrder = self.unfilteredCourses.allKeys as! [String]
        self.departmentHeadersInOrder.sortInPlace()
        self.departmentHeadersInOrder = self.departmentHeadersInOrder.filter{$0 != "Core"}
        self.departmentHeadersInOrder.insert("Core", atIndex: 0)
        //print(self.unfilteredCourses["Electrical Engineering"]!)
        print(self.departmentHeadersInOrder)
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
                return (self.filteredCourses[deptName]! as! [String]).count
            } else {
                return (self.unfilteredCourses[deptName]! as! [String]).count
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
                courseID = (self.filteredCourses[deptName]! as! [String])[indexPath.row]
                let courseDict = MyVariables.courses!.get(courseID)!
                cell.mainLabel.text = courseDict["Name"]! as! String
                cell.subLabel.text = courseID
                cell.courseObject = ObjectTuple(first: courseID, second: courseDict)
            } else {
                courseID = (self.unfilteredCourses[deptName]! as! [String])[indexPath.row]
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
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let def = NSUserDefaults.standardUserDefaults()
        let key = "favorites"
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        cell.delegateViewController = self
        cell.indexPath = indexPath
        if (indexPath.section == 1){
            var courseObj = ObjectTuple<NSString,NSDictionary>()
            if searching && searchBar.text != "" {
                courseObj = self.filteredCourses[indexPath.row]
                cell.mainLabel.text = courseObj.b!["Name"]! as! String
                cell.subLabel.text = courseObj.a! as String
                cell.courseObject = courseObj
            } else {
                courseObj = (MyVariables.courses?.get(indexPath.row))!//self.courses[indexPath.row]
                cell.mainLabel.text = courseObj.b!["Name"]! as! String
                cell.subLabel.text = courseObj.a! as String
                cell.courseObject = courseObj
            }
            //Selects the correct cells
            if (selectedCourseID == courseObj.a! as String){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                cell.setStarImage(favs.containsObject(cell.courseObject.a! as String))
            }
            
            return cell
        } else {
            //if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                let favID = favs[indexPath.row] as! String
                for i in 0...(MyVariables.courses?.count)!{
                    let courseDict = MyVariables.courses?.get(i)
                    if courseDict?.a! as! String == favID{
                        cell.mainLabel.text = courseDict!.b!["Name"]! as! String
                        cell.subLabel.text = courseDict!.a! as String
                        cell.courseObject = courseDict!
                        cell.setStarImage(true)
                        //Selects the correct cells
                        if (self.selectedCourseID == courseDict?.a! as! String){
                            cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
                        } else {
                            cell.backgroundColor = UIColor.whiteColor()
                        }
                        return cell
                    }
                }
            //}
            //Won't ever be called
            return cell
        }
    }
    */
    
    
    func updateSearchResults(){/*
        self.filteredCourses.removeAll(keepCapacity: false)
        
        var arr = [NSDictionary]()
        for i in 0...(MyVariables.courses?.count)!-1{
            let e = MyVariables.courses?.get(i)
            arr.append(["ID":e!.a! as String, "Name":e!.b!["Name"]! as! String])
        }
        
        //let arr: [NSDictionary] = [["Name":"Bob","ID":"12345"],["Name":"Mary","ID":"56789"]]
        
        let searchText = self.searchBar.text!
        
        let searchPredicate = NSPredicate(format: "SELF.Name CONTAINS[c] %@ OR SELF.ID CONTAINS[c] %@", searchText, searchText)
        
        let array = (arr as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        var objectTupleArray: [ObjectTuple<NSString,NSDictionary>] = []
        for i in array{
            let id = (i as! NSDictionary)["ID"] as! String
            let dict = MyVariables.courses!.get(id)!
            objectTupleArray.append(ObjectTuple(first: id, second: dict))
        }
        
        self.filteredCourses = objectTupleArray
        
        self.tableView.reloadData()
    */}
    
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

