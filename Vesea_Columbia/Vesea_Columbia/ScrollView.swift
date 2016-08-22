//
//  ScrollView.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/27/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import Charts

class ScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = panGestureRecognizer.velocityInView(self)
        print(fabs(velocity.y) < fabs(velocity.x))
        return fabs(velocity.y) < fabs(velocity.x)
    }
    
    func setHorizontalContentOffset(offset: CGPoint, velocity: CGPoint){
        print("Duration method")
        let xVelocity = velocity.x < 2400 ? 800 : velocity.x
        
        let xdistance = offset.x - self.contentOffset.x
        let duration = abs(xdistance/xVelocity)
        print(xVelocity)
        UIView.animateWithDuration(Double(duration), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.contentOffset = offset
            }, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.delegate?.isKindOfClass(BarChartView) == true || otherGestureRecognizer.delegate?.isKindOfClass(HorizontalBarChartView) == true  || otherGestureRecognizer.delegate?.isKindOfClass(PieChartView) == true ){
            return true
        } else {
            return false
        }
    }
 
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        if view is UIButton {
            return  true
        }
        return  super.touchesShouldCancelInContentView(view)
    }

}
