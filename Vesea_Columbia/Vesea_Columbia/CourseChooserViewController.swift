//
//  CourseChooserViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/5/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate, UIGestureRecognizerDelegate{
    
    var courseChooserType = ""
    
    var selectedCourseID : String?
    
    var unfilteredCourseDicts = NSMutableDictionary()
    var filteredCourseDicts = NSMutableDictionary()
    var departmentHeadersInOrder = [String]()
    
    var delegateViewController : QuestionViewController?
    
    var searching : Bool = false
    var shouldBeginEditing : Bool = true
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    
    // MARK: - Buttons
    
    @IBAction func removeButtonPressed(sender: AnyObject) {
            delegateViewController!.animateContainerOut()
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        searchBar.text = ""
        self.clearButton.hidden = true
        self.tableView.reloadData()
    }
    
    @IBAction func upSectionPressed(sender: AnyObject) {
        let currentSection = self.tableView.visibleSections.minElement()!
        let atTopOfCurrentSection = self.tableView.indexPathsForVisibleRows![0].row == 0
        print(atTopOfCurrentSection)
        var secToGoTo = currentSection - 1
            while secToGoTo > 0 && tableView.numberOfRowsInSection(secToGoTo) == 0{
                secToGoTo -= 1
            }
        
        if !atTopOfCurrentSection{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: currentSection), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else if secToGoTo == 0{
            self.tableView.setContentOffset(CGPointZero, animated: true)
        }
        else if self.tableView.numberOfRowsInSection(secToGoTo) > 0{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: secToGoTo), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
    }
    
    @IBAction func downSectionPressed(sender: AnyObject) {
        let currentSection = self.tableView.visibleSections.minElement()!
        
        if currentSection >= self.departmentHeadersInOrder.count-1 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: currentSection), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        } else {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: currentSection+1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
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
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.tableView.addGestureRecognizer(pan)
        
        self.view.layer.masksToBounds = true
        let border = CALayer()
        border.backgroundColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: CGFloat(0.5))
        border.borderWidth = 0
        self.view.layer.addSublayer(border)
        
        for i in 0...MyVariables.courses!.count-1{
            let course = MyVariables.courses!.get(i)
            if let arr = self.unfilteredCourseDicts.valueForKey(course!.b!["Department"]! as! String){
                (arr as! NSMutableArray).addObject(["ID":course!.a! as String,"Name":course!.b!["Name"]! as! String])
            } else {
                self.unfilteredCourseDicts.setValue(NSMutableArray.init(array: [["ID":course!.a! as String,"Name":course!.b!["Name"]! as! String]]), forKey: course!.b!["Department"]! as! String)
            }
        }
        self.departmentHeadersInOrder = self.unfilteredCourseDicts.allKeys as! [String]
        self.departmentHeadersInOrder.sortInPlace()
        self.departmentHeadersInOrder = self.departmentHeadersInOrder.filter{$0 != "Core"}
        self.departmentHeadersInOrder.insert("Core", atIndex: 0)
        //print(self.unfilteredCourseDicts["Electrical Engineering"]!)
        //print(self.departmentHeadersInOrder)
        
        
        let titleView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 72, height: 40)))
        let titleViewLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 72, height: 40)))
        let titleViewImage = UIImageView(frame: CGRect(x: 0, y: 33, width: 72, height: 5))
        titleViewImage.image = UIImage(named: "ic_arrow_drop_up")
        titleViewImage.contentMode = UIViewContentMode.ScaleAspectFit
        titleViewLabel.text = "Courses"
        titleViewLabel.textAlignment = NSTextAlignment.Center
        titleView.addSubview(titleViewLabel)
        titleView.addSubview(titleViewImage)
        titleView.addSubview(titleViewLabel)
        self.navBarTitle.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.navBarTitle.titleView?.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(self.navBarTitle.titleView?.frame)
    }
    
    // MARK: - Other TableView Methods
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        searchBar.resignFirstResponder()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
                if filteredCourseDicts[deptName]?.count == 0{
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
                return (self.filteredCourseDicts[deptName]! as! [NSDictionary]).count
            } else {
                return (self.unfilteredCourseDicts[deptName]! as! [NSDictionary]).count
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
            var courseDict = NSDictionary()
            let deptName = self.departmentHeadersInOrder[indexPath.section-1]
            if searching && searchBar.text != "" {
                courseDict = (self.filteredCourseDicts[deptName]! as! [NSDictionary])[indexPath.row]
                cell.mainLabel.text = courseDict["Name"]! as! String
                cell.subLabel.text = courseDict["ID"]! as! String
                cell.courseObject = ObjectTuple(first: courseDict["ID"]! as! String, second: courseDict)
            } else {
                courseDict = (self.unfilteredCourseDicts[deptName]! as! [NSDictionary])[indexPath.row]
                cell.mainLabel.text = courseDict["Name"]! as! String
                cell.subLabel.text = courseDict["ID"]! as! String
                cell.courseObject = ObjectTuple(first: courseDict["ID"]! as! String, second: courseDict)
                
            }

            //Selects the correct cells
            if (selectedCourseID == courseDict["ID"]! as! String){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey("favorites")) != nil){
                let favs = def.arrayForKey("favorites")! as NSArray
                cell.setStarImage(favs.containsObject(courseDict["ID"]! as! String))
            }
        }
        
        
        return cell
    }
    
    func updateSearchResults(){
        self.filteredCourseDicts.removeAllObjects()
        
        for key in self.unfilteredCourseDicts.allKeys{
            filteredCourseDicts.setValue(NSMutableArray(), forKey: key as! String)
        }
        
        let searchText = self.searchBar.text!
        
        let searchPredicate = NSPredicate(format: "SELF.Name CONTAINS[c] %@ OR SELF.ID CONTAINS[c] %@", searchText, searchText)
        for deptKey in unfilteredCourseDicts.allKeys{
          let unfilteredArr = unfilteredCourseDicts[deptKey as! String] as! NSMutableArray
            filteredCourseDicts[deptKey as! String] = unfilteredArr.filteredArrayUsingPredicate(searchPredicate)
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
    
    func handleTap(recognizer: UITapGestureRecognizer){
        self.tableView.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: - Scroll View Delegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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


extension UITableView {
    
    var visibleSections:Set<NSInteger> {
        var output = Set<NSInteger>()
        for ip in indexPathsForVisibleRows!{
            output.insert(ip.section)
        }
        return output
    }

}

