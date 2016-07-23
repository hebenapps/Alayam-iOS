//
//  PageViewController.swift
//  PageViewController
//
//  Created by jayaraj on 15/04/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource {

    var objPageViewController : UIPageViewController!
    var sliderNewsDetailsArr : NSMutableArray!
    var currentIndex : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        objPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        objPageViewController.dataSource = self
        objPageViewController.view.frame = self.view.bounds
        objPageViewController.view.hidden = false
        
        let subViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeDetailViewControllerID") as! HomeDetailViewController
        subViewController.sliderNewsDetails = sliderNewsDetailsArr.objectAtIndex(currentIndex) as! SliderNewsDTO
        subViewController.index = currentIndex
        objPageViewController.setViewControllers([subViewController], direction: .Forward, animated: true, completion: nil)
        
        self.addChildViewController(objPageViewController)
        self.view.addSubview(objPageViewController.view)
        self.objPageViewController.didMoveToParentViewController(self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index : Int) -> HomeDetailViewController {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeDetailViewControllerID") as! HomeDetailViewController
        controller.index = index
        controller.sliderNewsDetails = sliderNewsDetailsArr.objectAtIndex(index) as! SliderNewsDTO
        return controller
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let obj = viewController as! HomeDetailViewController
        var index = obj.index
        if index == sliderNewsDetailsArr.count-1 {
            return nil
        }
        index = index + 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! HomeDetailViewController).index
        if index == 0 {
            return nil
        }
        index = index - 1
        return viewControllerAtIndex(index)
        
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return sliderNewsDetailsArr.count
//    }
//
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return currentIndex
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
