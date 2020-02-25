//
//  HoldsPages.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class HoldsPages: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pages = [UIViewController]()
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
    }
    
    func setupPages(){
        let page1 = ViewController()
        let page2 = soundTableViewController()
        pages.append(page1)
        pages.append(page2)
        delegate=self
        dataSource=self
        setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    
//    Delegate methods
    //swipe backwards
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController){
             print("Back")
            if viewControllerIndex == 0 {
                //if you swipe back go to the last page
                return pages.last
            }else{
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    //swipe forwards
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("forward")

        if let viewControllerIndex = self.pages.firstIndex(of: viewController){
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil

    }

    
}
