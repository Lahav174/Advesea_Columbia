//
//  TableViewCell.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/21/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import QuartzCore

struct AdvesiaColors {
    static let majorColor = UIColor.redColor()
    static let class1Color = UIColor.greenColor()
    static let class2Color = UIColor.orangeColor()
}

class TableViewCell: UITableViewCell {
    
    var originalCenter = CGPoint()
    var swipingRight : Bool? = nil
    weak var delegateController = ListViewController()
    var indexPath = NSIndexPath()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let viewWidth = (delegateController?.delegate.view.frame.width)!
        let xVelocity = recognizer.velocityInView(superview!).x
        if recognizer.state == .Began {
            originalCenter = center
            self.delegateController?.delegate.resetQuestionViewController(self.indexPath.row)
        }
        if recognizer.state == .Changed {
            let originalOffset : CGFloat = 50
            let translation = recognizer.translationInView(self)
            if (swipingRight == nil && translation.x > 0){
                swipingRight = true
            } else if (swipingRight == nil && translation.x < 0){
                swipingRight = false
            }
            if (!swipingRight!){
                //print(frame.origin.x > -originalOffset)
                if (frame.origin.x > -originalOffset && xVelocity < 0){
                    //print("#1")
                    frame.origin.x = -originalOffset
                    if (translation.x < 0){
                        center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
                    } else if (translation.x >= 0){
                        center = CGPointMake(originalCenter.x, originalCenter.y)
                    }
                } else if (xVelocity > 0 && delegateController?.delegate.scrollView.contentOffset.x <= viewWidth) {
                    //print("#2")
                    if (translation.x < 0){
                        center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
                    } else if (translation.x >= 0){ 
                        //SCREEN SLIDES TOO FAR BEFORE GETTING RESET.
                        print("2.4: " + String(translation.x))
                        center = originalCenter
                    }
                    delegateController?.delegate.scrollView.contentOffset.x = viewWidth
                }
                else if (center.x < originalCenter.x && center.x - originalCenter.x < -45){
                    //print("#3")
                    frame.origin.x = -originalOffset
                    if (delegateController?.delegate.scrollView.contentOffset.x >= viewWidth){
                        delegateController?.delegate.scrollView.contentOffset.x = viewWidth - translation.x - originalOffset
                    } else {
                        delegateController?.delegate.scrollView.contentOffset.x = viewWidth
                    }
                }
            } else if (swipingRight!){
                if (translation.x >= 0){
                    delegateController?.delegate.scrollView.contentOffset.x = viewWidth - translation.x
                } else {
                    delegateController?.delegate.scrollView.contentOffset.x = viewWidth
                }
            }
        }
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            if (!swipingRight!){
                let scrollToNextPage = (delegateController?.delegate.scrollView.contentOffset.x)! > 1.45*viewWidth
                if (scrollToNextPage || xVelocity < -500){
                    let nextPage = CGPoint(x: viewWidth*2, y: 0)
                    delegateController?.delegate.scrollView.setContentOffset(nextPage, animated: true)
                    delegateController?.delegate.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate.scrollView.setContentOffset(thisPage, animated: true)
                }
            } else if (swipingRight!){
                print(delegateController?.delegate.scrollView.contentOffset.x)
                let scrollToPrevPage = (delegateController?.delegate.scrollView.contentOffset.x)! < 0.45*viewWidth
                if (scrollToPrevPage || xVelocity > 500){
                    let prevPage = CGPoint(x: 0, y: 0)
                    delegateController?.delegate.scrollView.setContentOffset(prevPage, animated: true)
                    delegateController?.delegate.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate.scrollView.setContentOffset(thisPage, animated: true)
                }
            }
            swipingRight = nil
        }
        
    }
    
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    //    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        let firstIsCell = (gestureRecognizer.delegate?.isMemberOfClass(TableViewCell))!
    //        let secondIsCell = (otherGestureRecognizer.delegate?.isMemberOfClass(TableViewCell))!
    //        if (firstIsCell && secondIsCell){
    //            return true
    //        } else {
    //            return false;
    //        }
    //    }
    
}