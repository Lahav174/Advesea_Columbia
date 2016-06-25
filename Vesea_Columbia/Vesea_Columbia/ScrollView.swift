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
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.delegate?.isKindOfClass(BarChartView) == true || otherGestureRecognizer.delegate?.isKindOfClass(HorizontalBarChartView) == true  || otherGestureRecognizer.delegate?.isKindOfClass(PieChartView) == true ){
            return true
        } else {
            return false
        }
    }
 

}
