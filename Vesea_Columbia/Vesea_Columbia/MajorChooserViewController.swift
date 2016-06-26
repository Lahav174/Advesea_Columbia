//
//  MajorChooserViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/5/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class MajorChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {
    
    var selectedCellCodes = [String]()
    
    var majors = [Major]()
    let majorArrayFromDefaults = NSUserDefaults.standardUserDefaults().objectForKey("majors") as! NSArray
    var filteredMajors = [Major]()
    
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
        
        navigationController!.navigationBar.delegate = self
        
        for e in majorArrayFromDefaults{
            majors.append(Major(courseName: e.objectForKey("name") as! String, school: e.objectForKey("school") as! String, code: e.objectForKey("code") as! String))
        }
                
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        self.tableView.reloadData()
        self.clearButton.hidden = true
        self.searchBar.addTarget(self, action: #selector(self.textfieldtextDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: -10, y: searchBar.frame.size.height - width - 43 - 8, width:  view.frame.size.width*2, height: searchBar.frame.size.height+8)
        
        border.borderWidth = width
        self.view.layer.addSublayer(border)
        self.view.layer.masksToBounds = true
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
                return self.filteredMajors.count
            } else {
                return self.majors.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MajorTableViewCell
        cell.delegateViewController = self
        cell.indexPath = indexPath
        
        if (indexPath.section == 1){
            var majorObj = Major()
            if searching && searchBar.text != "" {
                majorObj = self.filteredMajors[indexPath.row]
                cell.mainLabel.text = majorObj.name
                cell.subLabel.text = majorObj.school
                cell.majorObject = majorObj
            } else {
                majorObj = self.majors[indexPath.row]
                cell.mainLabel.text = majorObj.name
                cell.subLabel.text = majorObj.school
                cell.majorObject = majorObj
            }
            //Selects the correct cells
            if (selectedCellCodes.contains(majorObj.code)){
                cell.backgroundColor = UIColor(red: 196/255, green: 216/255, blue: 226/255, alpha: 0.6)
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
            //Stars the correct cells
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                cell.setStarImage(favs.containsObject(cell.majorObject.code))
            }
            
            return cell
        } else {
            if ((def.arrayForKey(key)) != nil){
                let favs = def.arrayForKey(key)! as NSArray
                let code = favs[indexPath.row] as! String
                for fm in self.majors{
                    if fm.code == code{
                        cell.mainLabel.text = fm.name
                        cell.subLabel.text = fm.school
                        cell.majorObject = fm
                        cell.setStarImage(true)
                        //Selects the correct cells
                        if (selectedCellCodes.contains(fm.code)){
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
        self.filteredMajors.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", self.searchBar.text!)
        
        let array = (self.majors as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredMajors = array as! [Major]
        
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

class Major : NSObject {
    
    var name = String()
    var school = String?()
    var code = String()
    
    init(courseName: String, school: String, code: String) {
        super.init()
        self.name = courseName
        self.school = school
        self.code = code
    }
    
    override init(){
        super.init()
    }
    
}


