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
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("ScrollView Touched")
//    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.delegate?.isKindOfClass(BarChartView) == true){
            return true
        } else {
            return false
        }
    }

}
