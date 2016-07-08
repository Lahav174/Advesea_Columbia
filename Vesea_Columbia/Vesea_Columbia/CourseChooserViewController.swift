//
//  CourseChooserViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/5/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {
    
    var selectedCellCodes = [String]()
    
    var courses = [Course]()
    var filteredCourses = [Course]()
    
    var delegateViewController = UIViewController()
    
    var searching : Bool = false
    var shouldBeginEditing : Bool = true
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func removeButtonPressed(sender: AnyObject) {
        if (delegateViewController.isKindOfClass(QuestionViewController)){
            let vc = delegateViewController as! QuestionViewController
            vc.animateContainerOut()
        }
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
        print("#2")
        for e in MyVariables.courses!{
            courses.append(Course(courseName: e.objectForKey("Name") as! String,
                courseID: e.objectForKey("ID") as! String,
                callNumber: e.objectForKey("Call") as! String,
                credit: Int(e.objectForKey("Credits") as! String)!))
        }
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
    
    func selectCellsWithCodes(codes: [String])
    {
        var tempSelectedCellCodes = [String]()
        for c in codes{
            if !(self.selectedCellCodes.contains(c)){
                tempSelectedCellCodes.append(c)
            }
        }
        selectedCellCodes.removeAll()
        selectedCellCodes.appendContentsOf(tempSelectedCellCodes)
        print(selectedCellCodes)
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
                return self.courses.count
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
        let def = NSUserDefaults.standardUserDefaults()
        let key = "favorites"
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        cell.delegateViewController = self
        cell.indexPath = indexPath
        
        if (indexPath.section == 1){
            var courseObj = Course()
            if searching && searchBar.text != "" {
                courseObj = self.filteredCourses[indexPath.row]
                cell.mainLabel.text = courseObj.name
                cell.subLabel.text = courseObj.ID
                cell.courseObject = courseObj
            } else {
                courseObj = self.courses[indexPath.row]
                cell.mainLabel.text = courseObj.name
                cell.subLabel.text = courseObj.ID
                cell.courseObject = courseObj
            }
            //Selects the correct cells
            if (selectedCellCodes.contains(courseObj.call)){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                cell.setStarImage(favs.containsObject(cell.courseObject.call))
            }
            
            return cell
        } else {
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                let code = favs[indexPath.row] as! String
                for fm in self.courses{
                    if fm.call == code{
                        cell.mainLabel.text = fm.name
                        cell.subLabel.text = fm.ID
                        cell.courseObject = fm
                        cell.setStarImage(true)
                        //Selects the correct cells
                        if (selectedCellCodes.contains(fm.call)){
                            cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
                        } else {
                            cell.backgroundColor = UIColor.whiteColor()
                        }
                    }
                }
                return cell
            } else {
                //Won't ever be called
                return cell
            }
            
        }
    }
    
    
    func updateSearchResults(){
        self.filteredCourses.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", self.searchBar.text!)
        
        let array = (self.courses as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredCourses = array as! [Course]
        
        self.tableView.reloadData()
    }
    
    /////
    
    func textfieldtextDidChange(textField: UITextField){
        print("Changed")
        if !(searchBar.isFirstResponder()){
            shouldBeginEditing = false
        }
        updateSearchResults()
        clearButton.hidden = (textField.text == "")
        updateSearchResults()
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        if !(searchBar.isFirstResponder()){
//            shouldBeginEditing = false
//        }
//        updateSearchResults()
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return false
    }
    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        print("Done")
//        searchBar.resignFirstResponder()
//    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let boolToReturn = shouldBeginEditing
        shouldBeginEditing = true
        return boolToReturn
    }
    
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        let boolToReturn = shouldBeginEditing
//        shouldBeginEditing = true
//        return boolToReturn
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("#1")
        searching = true
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        print("#1")
//        searching = true
//    }
    //////
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
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

class Course : NSObject {
    
    var name = String()
    var call = String()
    var ID = String()
    var credits = Int()
    
    init(courseName: String, courseID: String, callNumber: String, credit: Int) {
        super.init()
        self.name = courseName
        self.call = callNumber
        self.ID = courseID
        self.credits = credit
    }
    
    override init(){
        super.init()
    }
    
}


