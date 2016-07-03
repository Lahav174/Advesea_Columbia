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
        let viewWidth = (delegateController?.delegate!.view.frame.width)!
        let xVelocity = recognizer.velocityInView(superview!).x
        if recognizer.state == .Began {
            if (iconView.image == nil){
                slidingView.clipsToBounds = true
                iconView.image = UIImage(named: "graph_icon")
                self.slidingView.backgroundColor = UIColor.blackColor()
            }
            originalSlidingViewOrigin = slidingView.frame.origin
            self.delegateController?.delegate!.resetQuestionViewController(self.indexPath.section)
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
                        let thisPage = CGPoint(x: viewWidth, y: 0)
                        delegateController?.delegate!.scrollView.setContentOffset(thisPage, animated: true)
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
            
            let offset = slidingView.frame.origin.x
            self.slidingImageView?.frame.origin.x = -offset
            
        }
        if recognizer.state == .Ended {
            UIView.animateWithDuration(0.2, animations: {
                self.slidingView.frame.origin.x = 0
                self.slidingImageView?.frame.origin.x = 0
            })
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