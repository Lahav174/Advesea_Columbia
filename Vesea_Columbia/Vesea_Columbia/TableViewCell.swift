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
    var originalSlidingViewOrigin = CGPoint()
    var swipingRight : Bool? = nil
    weak var delegateController = ListViewController()
    var indexPath = NSIndexPath()
    
    @IBOutlet weak var slidingView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("NSCoding not supported")
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    func setup(){
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        
        self.backgroundColor = UIColor.orangeColor()
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        let viewWidth = (delegateController?.delegate!.view.frame.width)!
        let xVelocity = recognizer.velocityInView(superview!).x
        let maxSlidingDistance : CGFloat = -50
        if recognizer.state == .Began {
            originalSlidingViewOrigin = slidingView.frame.origin
            self.delegateController?.delegate!.resetQuestionViewController(self.indexPath.row)
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            if (swipingRight == nil && translation.x > 0){
                swipingRight = true
            } else if (swipingRight == nil && translation.x < 0){
                swipingRight = false
            }
            if (!swipingRight!){
                if (slidingView.frame.origin.x > maxSlidingDistance && xVelocity < 0){
                    self.slidingView.frame.origin.x = maxSlidingDistance
                    if (translation.x < 0){
                        slidingView.frame.origin = CGPoint(x: originalSlidingViewOrigin.x + translation.x, y: originalSlidingViewOrigin.y)
                    } else if (translation.x >= 0){
                        slidingView.frame.origin = originalSlidingViewOrigin
                    }
                } else if (xVelocity > 0 && delegateController?.delegate!.scrollView.contentOffset.x <= viewWidth){
                    if (translation.x < 0){
                        slidingView.frame.origin = CGPoint(x: originalSlidingViewOrigin.x + translation.x, y: originalSlidingViewOrigin.y)
                    } else if (translation.x >= 0){
                        slidingView.frame.origin = originalSlidingViewOrigin
                    }
                } else if (slidingView.frame.origin.x < originalSlidingViewOrigin.x && slidingView.frame.origin.x - originalSlidingViewOrigin.x < (maxSlidingDistance + 5)){
                    slidingView.frame.origin.x = maxSlidingDistance
                    if (delegateController?.delegate!.scrollView.contentOffset.x >= viewWidth){
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x + maxSlidingDistance
                    } else {
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                    }
                }
            } else if (swipingRight!){
                if (translation.x >= 0){
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x
                } else {
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                }
            }
            
        }
        if recognizer.state == .Ended {
            UIView.animateWithDuration(0.2, animations: {self.slidingView.frame.origin.x = 0})
            if (!swipingRight!){
                let scrollToNextPage = (delegateController?.delegate!.scrollView.contentOffset.x)! > 1.45*viewWidth
                if (scrollToNextPage || xVelocity < -500){
                    let nextPage = CGPoint(x: viewWidth*2, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(nextPage, animated: true)
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                }
            } else if (swipingRight!){
                let scrollToPrevPage = (delegateController?.delegate!.scrollView.contentOffset.x)! < 0.45*viewWidth
                if (scrollToPrevPage || xVelocity > 500){
                    let prevPage = CGPoint(x: 0, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(prevPage, animated: true)
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                }
            }
            swipingRight = nil
        }
    }
    
    /*
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let viewWidth = (delegateController?.delegate!.view.frame.width)!
        let xVelocity = recognizer.velocityInView(superview!).x
        if recognizer.state == .Began {
            originalCenter = center
            self.delegateController?.delegate!.resetQuestionViewController(self.indexPath.row)
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
                        center = originalCenter
                    }
                } else if (xVelocity > 0 && delegateController?.delegate!.scrollView.contentOffset.x <= viewWidth) {
                    //print("#2")
                    if (translation.x < 0){
                        center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
                    } else if (translation.x >= 0){ 
                        //SCREEN SLIDES TOO FAR BEFORE GETTING RESET.
                        print("2.4: " + String(translation.x))
                        center = originalCenter
                    }
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                }
                else if (center.x < originalCenter.x && center.x - originalCenter.x < -45){
                    //print("#3")
                    frame.origin.x = -originalOffset
                    if (delegateController?.delegate!.scrollView.contentOffset.x >= viewWidth){
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x - originalOffset
                    } else {
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                    }
                }
            } else if (swipingRight!){
                if (translation.x >= 0){
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x
                } else {
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                }
            }
        }
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            if (!swipingRight!){
                let scrollToNextPage = (delegateController?.delegate!.scrollView.contentOffset.x)! > 1.45*viewWidth
                if (scrollToNextPage || xVelocity < -500){
                    let nextPage = CGPoint(x: viewWidth*2, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(nextPage, animated: true)
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                }
            } else if (swipingRight!){
                print(delegateController?.delegate!.scrollView.contentOffset.x)
                let scrollToPrevPage = (delegateController?.delegate!.scrollView.contentOffset.x)! < 0.45*viewWidth
                if (scrollToPrevPage || xVelocity > 500){
                    let prevPage = CGPoint(x: 0, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(prevPage, animated: true)
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                }
            }
            swipingRight = nil
        }
        
    }
    */
    
    
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