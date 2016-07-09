//
//  CourseTableViewCell.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 6/6/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    var courseObject = Course()
    
    var delegateViewController = CourseChooserViewController() //make optional
    
    //var tableView = UITableView()
    
    var indexPath = NSIndexPath()
    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBAction func starButtonPressed(sender: AnyObject) {
        let def = NSUserDefaults.standardUserDefaults()
        let key = "favorites"
        var favorites = NSMutableArray()
        
        if ((def.arrayForKey(key)) != nil){
            let defArray = def.arrayForKey(key)! as NSArray
            favorites = defArray.mutableCopy() as! NSMutableArray
        }

        if favorites.containsObject(courseObject.call){//It is currently a favorite
            print("Un-Favorited!")
            setStarImage(false)
            favorites.removeObject(courseObject.call)
        } else { //It is not currently a favorite
            setStarImage(true)
            print("Favorited!")
            favorites.addObject(courseObject.call)
        }
        let arrayToSet = favorites as NSArray
        def.setObject(arrayToSet, forKey: key)
        
        self.delegateViewController.tableView.reloadData()
        
        if self.indexPath.section == 1 && favorites.containsObject(courseObject.call){//Just became a favorite (Need to move down)
            let offset = CGPoint(x: 0, y: self.delegateViewController.tableView.contentOffset.y + 44)
            self.delegateViewController.tableView.setContentOffset(offset, animated: false)
        } else if (self.indexPath.section == 1 && self.delegateViewController.tableView.contentOffset.y >= 0){
            let offset = CGPoint(x: 0, y: self.delegateViewController.tableView.contentOffset.y - 44)
            self.delegateViewController.tableView.setContentOffset(offset, animated: false)
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
        self.delegateViewController.selectCellWithCall(self.courseObject.call)
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
