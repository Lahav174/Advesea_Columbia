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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    // MARK: - Buttons
    
    
    @IBAction func infoButtonPressed(sender: AnyObject) {
        let tuple = ObjectTuple<NSString,NSDictionary>(first: self.subTitleLabel.text, second: [:])
        self.delegateViewController!.addInfoView(tuple)
    }

    @IBAction func locateButtonPressed(sender: AnyObject) {
    }
    
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
        var sectionToGoTo = currentSection - 1
            while sectionToGoTo > 0 && tableView.numberOfRowsInSection(sectionToGoTo) == 0{
                sectionToGoTo -= 1
            }
        
        if !atTopOfCurrentSection{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: currentSection), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else if sectionToGoTo == 0{
            self.tableView.setContentOffset(CGPointZero, animated: true)
        }
        else if sectionToGoTo >= 0 && self.tableView.numberOfRowsInSection(sectionToGoTo) > 0{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sectionToGoTo), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
    }
    
    @IBAction func downSectionPressed(sender: AnyObject) {
        let currentSection = self.tableView.visibleSections.minElement()!
        
        var sectionToGoTo = currentSection + 1
        while self.tableView.numberOfRowsInSection(sectionToGoTo) == 0{//don't have to check that its in range
            sectionToGoTo += 1
        }
        
        if currentSection < self.departmentHeadersInOrder.count-1{
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sectionToGoTo), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
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
        let def = NSUserDefaults.standardUserDefaults()
        self.unfilteredCourseDicts.setValue(NSMutableArray.init(array: NSMutableArray(array: [])), forKey: "Favorites")
        for favID in def.arrayForKey("favorites")!{
            let dict = MyVariables.courses!.get((favID as! String))
            let arr = self.unfilteredCourseDicts.valueForKey("Favorites")
            (arr as! NSMutableArray).addObject(["ID":(favID as! String),"Name":dict!["Name"]! as! String])
        }
        
        self.departmentHeadersInOrder = self.unfilteredCourseDicts.allKeys as! [String]
        self.departmentHeadersInOrder.sortInPlace()
        self.departmentHeadersInOrder = self.departmentHeadersInOrder.filter{$0 != "Core"}
        self.departmentHeadersInOrder.insert("Core", atIndex: 0)
        self.departmentHeadersInOrder.insert("Favorites", atIndex: 0)
        self.departmentHeadersInOrder = self.departmentHeadersInOrder.filter{$0 != "Other"}
        self.departmentHeadersInOrder.insert("Other", atIndex: departmentHeadersInOrder.count-1)
        
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
        var id = String()
        if (type == "class 1"){
            id = def.objectForKey("selectedCourse1") as! String
            self.titleLabel.textColor = K.colors.course1Color
            self.subTitleLabel.textColor = K.colors.course1Color
            
        } else if (type == "class 2"){
            id = def.objectForKey("selectedCourse2") as! String
            self.titleLabel.textColor = K.colors.course2Color
            self.subTitleLabel.textColor = K.colors.course2Color
        }
        let dict = MyVariables.courses?.get(id)
        self.selectedCourseID = id
        self.titleLabel.text = dict!["Name"]! as? String
        self.subTitleLabel.text = id
        
        self.tableView.reloadData()
    }
    
    func selectCellWithID(ID: String)
    {
        let def = NSUserDefaults.standardUserDefaults()
        
        if self.selectedCourseID != ID{
            selectedCourseID = ID
            let dict = MyVariables.courses?.get(ID)
            if (self.courseChooserType == "class 1"){
                self.titleLabel.textColor = K.colors.course1Color
                self.subTitleLabel.textColor = K.colors.course1Color
                def.setObject(ID, forKey: "selectedCourse1")
            } else if (self.courseChooserType == "class 2"){
                self.titleLabel.textColor = K.colors.course2Color
                self.subTitleLabel.textColor = K.colors.course2Color
                def.setObject(ID, forKey: "selectedCourse2")
            }
            self.titleLabel.text = dict!["Name"]! as? String
            self.subTitleLabel.text = ID
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView DataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.departmentHeadersInOrder.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        headerView.backgroundColor = UIColor.lightGrayColor()
        headerView.textAlignment = NSTextAlignment.Center
        headerView.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        
        headerView.text = self.departmentHeadersInOrder[section]
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let deptName = self.departmentHeadersInOrder[section]
        if searching && searchBar.text != "" {
            if filteredCourseDicts[deptName]?.count == 0{
                return 0
            }
        } 
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let deptName = self.departmentHeadersInOrder[section]
        if searching && searchBar.text != ""{
            return (self.filteredCourseDicts[deptName]! as! [NSDictionary]).count
        } else {
            return (self.unfilteredCourseDicts[deptName]! as! [NSDictionary]).count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let def = NSUserDefaults.standardUserDefaults()
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        cell.delegateViewController = self
        cell.indexPath = indexPath
        
        var courseDict = NSDictionary()
        let deptName = self.departmentHeadersInOrder[indexPath.section]
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

