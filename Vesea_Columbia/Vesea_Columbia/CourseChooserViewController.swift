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
    
    //var courseIDs = [String]()
    var filteredCourses = [ObjectTuple<NSString,NSDictionary>]()
    
    var delegateViewController : QuestionViewController?
    
    var searching : Bool = false
    var shouldBeginEditing : Bool = true
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func removeButtonPressed(sender: AnyObject) {
            delegateViewController!.animateContainerOut()
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        searchBar.text = ""
        self.clearButton.hidden = true
        self.tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Top
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
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
    }
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
            headerView.text = "All Courses"
        }
        
        return headerView
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1){
            if searching && searchBar.text != ""{
                return self.filteredCourses.count
            } else {
                return (MyVariables.courses?.count)!//self.courses.count
            }
        } else {
            let def = NSUserDefaults.standardUserDefaults()
            let key = "favorites"
            
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                return favs.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("#1")
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
                cell.subLabel.text = courseObj.a! as! String
                cell.courseObject = courseObj
            } else {
                courseObj = (MyVariables.courses?.get(indexPath.row))!//self.courses[indexPath.row]
                cell.mainLabel.text = courseObj.b!["Name"]! as! String
                cell.subLabel.text = courseObj.a! as! String
                cell.courseObject = courseObj
            }
            //Selects the correct cells
            if (selectedCourseID == courseObj.a! as! String){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                cell.setStarImage(favs.containsObject(cell.courseObject.a! as! String))
            }
            
            return cell
        } else {
            print("#2")
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                let favID = favs[indexPath.row] as! String
                for i in 0...(MyVariables.courses?.count)!{
                    let courseDict = MyVariables.courses?.get(i)
                    if courseDict?.a! as! String == favID{
                        print("#2.5")
                        cell.mainLabel.text = courseDict!.b!["Name"]! as! String
                        cell.subLabel.text = courseDict!.a! as! String
                        cell.courseObject = courseDict!
                        cell.setStarImage(true)
                        print("#2.7")
                        //Selects the correct cells
                        if (self.selectedCourseID == courseDict?.a! as! String){
                            cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
                        } else {
                            print("2.8.y")
                            cell.backgroundColor = UIColor.whiteColor()
                            print("2.8.z")
                        }
                        return cell
                    }
                }
            }
            //Won't ever be called
            return cell
        }
    }
    
    
    func updateSearchResults(){
//        self.filteredCourses.removeAll(keepCapacity: false)
//        
//        var arr = [NSDictionary]()
//        for i in 0...(MyVariables.courses?.count)!-1{
//            let e = MyVariables.courses?.get(i)
//            arr.append(["ID":e!.a! as String, "Name":e!.b!["Name"]! as! String])
//        }
//        
//        //let arr: [NSDictionary] = [["Name":"Bob","ID":"12345"],["Name":"Mary","ID":"56789"]]
//        
//        let searchText = self.searchBar.text!
//        
//        let searchPredicate = NSPredicate(format: "SELF.Name CONTAINS[c] %@ OR SELF.ID CONTAINS[c] %@", searchText, searchText)
//        
//        let array = (arr as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        
//        var objectTupleArray: [ObjectTuple<NSString,NSDictionary>] = []
//        for i in array{
//            let id = (i as! NSDictionary)["ID"] as! String
//            let dict = MyVariables.courses!.get(id)!
////            objectTupleArray.append(ObjectTuple(first: id, second: dict))
//        }
//        
//        //self.filteredCourses = objectTupleArray
//        
//        //self.tableView.reloadData()
    }
    
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
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

