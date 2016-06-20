//
//  PageViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/17/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var pageNumber = 1;
    var listPage = ListViewController()
    var frontPage = FrontViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frontPage = storyboard?.instantiateViewControllerWithIdentifier("frontvc") as! FrontViewController
        setViewControllers([frontPage], direction: .Forward, animated: false, completion: nil)
        dataSource = self
        
        listPage = storyboard?.instantiateViewControllerWithIdentifier("listvc") as! ListViewController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        switch viewController.title! {
        case "FrontViewController":
            return listPage
        default:
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        switch viewController.title! {
        case "ListViewController":
            return frontPage
        default:
            return nil
        }
    }
}
