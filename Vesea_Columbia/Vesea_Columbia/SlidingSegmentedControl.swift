//
//  SlidingSegmentedControl.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 7/3/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class SlidingSegmentedControl: UIView {
    
    var selectedSegmentIndex : Int = -1
    var buttons = [UIButton]()
    var underlineBar = UIView()
    var delegate : SlidingSegmentedControlDelegate?

    init(frame: CGRect, buttonTitles: [String]) {
        super.init(frame: frame)
        
        setup(buttonTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup([])
    }
    
    func setup(buttonTitles: [String]){
        print("Segmented Control initialized!")
        self.backgroundColor = K.colors.segmentedControlBackgroundColor
        let numberOfSegments = buttonTitles.count
        selectedSegmentIndex = Int((numberOfSegments-1)/2)
        
        var collectiveButtonWidth : CGFloat = 0
        for i in 0...numberOfSegments-1{
            let button = UIButton()
            button.setTitle(buttonTitles[i], forState: .Normal)
            let buttonSize = button.titleLabel?.intrinsicContentSize()
            collectiveButtonWidth += (buttonSize?.width)!
            button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            button.frame.size = buttonSize!
            buttons.insert(button, atIndex: i)
        }
        let spaceBetweenButtons = (self.frame.width-collectiveButtonWidth)/CGFloat(buttons.count+1)
        var newButtonOriginX : CGFloat = 0 + spaceBetweenButtons
        for i in 0...numberOfSegments-1{
            let buttonSize = buttons[i].frame.size
            buttons[i].frame.origin = CGPoint(x: newButtonOriginX, y: self.frame.height/2 - buttonSize.height/2)
            newButtonOriginX += buttonSize.width + spaceBetweenButtons
            self.addSubview(buttons[i])
        }
        
        let underlinedButtonFrame = buttons[selectedSegmentIndex].frame
        underlineBar.frame = CGRect(x: underlinedButtonFrame.minX, y: self.frame.height-1, width: underlinedButtonFrame.width, height: 1)
        underlineBar.backgroundColor = UIColor.whiteColor()
        self.addSubview(underlineBar)
        
    }
    
    func buttonAction(sender: UIButton!) {
        let buttonIndex = buttons.indexOf(sender)!
        if (buttonIndex != self.selectedSegmentIndex){
            selectedSegmentIndex = buttonIndex
            let underlinedButtonFrame = buttons[selectedSegmentIndex].frame
            
            if (delegate != nil){
                delegate?.SlidingSegmentedControlDidSelectIndex(buttonIndex)
            }
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.underlineBar.frame = CGRect(x: underlinedButtonFrame.minX, y: self.frame.height-1, width: underlinedButtonFrame.width, height: 1)
                }, completion: nil)
        }
    }
}

protocol SlidingSegmentedControlDelegate {
    func SlidingSegmentedControlDidSelectIndex(index: Int)
}
