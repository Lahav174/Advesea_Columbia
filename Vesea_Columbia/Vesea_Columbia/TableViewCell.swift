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
    let maxSlidingDistance : CGFloat = -100
    var slidingImageView : UIImageView?
    
    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet weak var slidingViewLabel: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
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
        //self.slidingView.backgroundColor = UIColor.blackColor()would crash anyway
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        assert(delegateController != nil)
        assert(delegateController?.delegate != nil)
        assert(delegateController?.delegate!.view.frame.width != nil)
        let viewWidth = (delegateController?.delegate!.view.frame.width)!
        let xVelocity = recognizer.velocityInView(superview!).x
        if recognizer.state == .Began {
            if (self.iconView.image == nil){
                self.slidingView.clipsToBounds = true
                self.iconView.image = UIImage(named: "graph_icon")
                self.slidingView.backgroundColor = UIColor.blackColor()
                self.originalSlidingViewOrigin = self.slidingView.frame.origin
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.delegateController?.delegate!.resetQuestionViewController(self.indexPath.section)
            }
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            if (swipingRight == nil && translation.x > 0){
                swipingRight = true
            } else if (swipingRight == nil && translation.x < 0){
                swipingRight = false
            }
            if (!swipingRight!){
                if (slidingView.frame.origin.x > maxSlidingDistance && xVelocity < 0){//not pulled that far, pulling back
                    print("#1")
                    self.slidingView.frame.origin.x = maxSlidingDistance
                    if (translation.x < 0){
                        slidingView.frame.origin = CGPoint(x: originalSlidingViewOrigin.x + translation.x, y: originalSlidingViewOrigin.y)
                    } else if (translation.x >= 0){
                        slidingView.frame.origin = originalSlidingViewOrigin
                    }
                } else if (xVelocity > 0 && (delegateController?.delegate!.scrollView.contentOffset.x)! < viewWidth+3){
                    //pushing forward, less than max forward distance
                    print("#2")
                    if (translation.x < 0){
                        slidingView.frame.origin = CGPoint(x: originalSlidingViewOrigin.x + translation.x, y: originalSlidingViewOrigin.y)
                    } else if (translation.x >= 0){
                        slidingView.frame.origin = originalSlidingViewOrigin
                        let thisPage = CGPoint(x: viewWidth, y: 0)
                        delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                    }
                } else if (slidingView.frame.origin.x < originalSlidingViewOrigin.x && slidingView.frame.origin.x - originalSlidingViewOrigin.x < (maxSlidingDistance + 5)){
                    print("#3")
                    slidingView.frame.origin.x = maxSlidingDistance
                    if ((delegateController?.delegate!.scrollView.contentOffset.x)! >= viewWidth && maxSlidingDistance >= translation.x){
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x + maxSlidingDistance
                    } else {
                        delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                    }
                } else {
                    print("#4")
                }
            } else if (swipingRight!){
                if (translation.x >= 0){
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth - translation.x
                } else {
                    delegateController?.delegate!.scrollView.contentOffset.x = viewWidth
                }
            }
            
            let offset = slidingView.frame.origin.x
            self.slidingImageView?.frame.origin.x = -offset
            
        }
        if recognizer.state == .Ended {
           
            if (!swipingRight!){
                let scrollToNextPage = (delegateController?.delegate!.scrollView.contentOffset.x)! > 1.35*viewWidth
                if (scrollToNextPage || xVelocity < -500){
                    let nextPage = CGPoint(x: viewWidth*2 + K.Others.screenGap*2, y: 0)
                    if xVelocity < -500{
                    delegateController?.delegate!.scrollView.setHorizontalContentOffset(nextPage, velocity: recognizer.velocityInView(self))
                    } else {
                        delegateController?.delegate!.scrollView.setContentOffset(nextPage, animated: true)
                    }
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                    UIView.animateWithDuration(0.2, animations: {
                        self.slidingView.frame.origin.x = self.maxSlidingDistance
                        self.slidingImageView?.frame.origin.x = -self.maxSlidingDistance
                    })
                } else {
                    let thisPage = CGPoint(x: viewWidth + K.Others.screenGap, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
                    UIView.animateWithDuration(0.2, animations: {
                        self.slidingView.frame.origin.x = 0
                        self.slidingImageView?.frame.origin.x = 0
                    })
                }
            } else if (swipingRight!){
                let scrollToPrevPage = (delegateController?.delegate!.scrollView.contentOffset.x)! < 0.55*viewWidth
                if (scrollToPrevPage || xVelocity > 500){
                    let prevPage = CGPoint(x: 0, y: 0)
                    if xVelocity > 500{
                        delegateController?.delegate!.scrollView.setHorizontalContentOffset(prevPage, velocity: recognizer.velocityInView(self))
                    } else {
                        delegateController?.delegate!.scrollView.setContentOffset(prevPage, animated: true)
                    }
                    delegateController?.delegate!.scrollView.panGestureRecognizer.enabled = true
                } else {
                    let thisPage = CGPoint(x: viewWidth + K.Others.screenGap, y: 0)
                    delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
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