//
//  CourseTableViewCell.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/6/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    var courseObject = ObjectTuple<NSString,NSDictionary>()
    
    var delegateViewController : CourseChooserViewController? //make optional
    
    //var tableView = UITableView()
    
    var indexPath = NSIndexPath()
    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBAction func infoButtonPressed(sender: AnyObject) {
       //delegateViewController!.delegateViewController!.addInfoView(courseObject)
    }
    
    
    @IBAction func starButtonPressed(sender: AnyObject) {
        let def = NSUserDefaults.standardUserDefaults()
        let key = "favorites"
        var favorites = NSMutableArray()
        
        if ((def.arrayForKey(key)) != nil){
            let defArray = def.arrayForKey(key)! as NSArray
            favorites = defArray.mutableCopy() as! NSMutableArray
        }

        if favorites.containsObject(courseObject.a! as! String){//It is currently a favorite
            //print("Un-Favorited!")
            setStarImage(false)
            favorites.removeObject(courseObject.a! as! String)
        } else { //It is not currently a favorite
            setStarImage(true)
            //print("Favorited!")
            favorites.addObject(courseObject.a! as! String)
        }
        let arrayToSet = favorites as NSArray
        def.setObject(arrayToSet, forKey: key)
        
        let contentOffset = self.delegateViewController!.tableView.contentOffset.y
        let rowsInFirstSection =  CGFloat((self.delegateViewController!.tableView.numberOfRowsInSection(0))*44 + 25)
        
        self.delegateViewController!.tableView.reloadData()
        
        let sectionOneIsVisible = rowsInFirstSection > contentOffset
    
        if self.indexPath.section > 0 && favorites.containsObject(courseObject.a! as! String) && !sectionOneIsVisible{//Just became a favorite (Need to move down)
            let offset = CGPoint(x: 0, y: self.delegateViewController!.tableView.contentOffset.y + 44)
            self.delegateViewController!.tableView.setContentOffset(offset, animated: false)
        }
        else if (self.indexPath.section > 0 && self.delegateViewController!.tableView.contentOffset.y >= 0){
            let offset = CGPoint(x: 0, y: self.delegateViewController!.tableView.contentOffset.y - 44)
            self.delegateViewController!.tableView.setContentOffset(offset, animated: false)
        }
        
        if (self.delegateViewController!.tableView.contentOffset.y < 0){
            self.delegateViewController!.tableView.setContentOffset(CGPointZero, animated: false)
        }

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("NSCoding not supported")
        
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setStarImage(shouldBeEnabled: Bool){
        if shouldBeEnabled{
            starButton.setImage(UIImage(named: "Star_Selected"), forState: UIControlState.Normal)
        } else {
            starButton.setImage(UIImage(named: "Star_Deselected"), forState: UIControlState.Normal)
        }
    }
    
    func handlePress(recognizer: UILongPressGestureRecognizer){
        print("Pressed")
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){
        self.delegateViewController!.selectCellWithID(courseObject.a! as! String)
    }
    
    func setup(){
        let pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePress(_:)))
        self.addGestureRecognizer(pressRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
