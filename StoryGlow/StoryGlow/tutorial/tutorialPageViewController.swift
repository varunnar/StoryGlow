//
//  tutorialPageViewController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/26/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class tutorialPageViewController: UIViewController {
    
    var tutorialPageArrayImage = [String]()
    var tutorialPageArrayLabel = [String]()
    var pageControl =  UIPageControl()
    var pageviewControl = UIPageViewController()
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
        pageviewControl.delegate = self
        pageviewControl.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(dismissTutorial), name: Notification.Name(rawValue: "endTutorial"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissTutorial()
    {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setupPageViewController(){
        pageviewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        for i in 0...tutorialPageArrayImage.count-1{
            let page = tutorialPage()
            page.imageString = tutorialPageArrayImage[i]
            page.imageLabelString = tutorialPageArrayLabel[i]
            pages.append(page)
        }
        addChild(pageviewControl)
        view.addSubview(pageviewControl.view)
        pageviewControl.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageviewControl.view.frame = self.view.bounds
        pageviewControl.didMove(toParent: self)
        view.gestureRecognizers = pageviewControl.gestureRecognizers
        
    }
    
    func setupPageControl(){
        pageControl.frame = CGRect(x: 50, y: 300, width: 200, height: 20)
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageviewControl.view.addSubview(pageControl)
        PageControlConstraints()
    }
    
    func PageControlConstraints()
    {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: pageviewControl.view.bottomAnchor, constant: -10).isActive = true
        pageControl.widthAnchor.constraint(equalTo: pageviewControl.view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: pageviewControl.view.centerXAnchor).isActive = true
        pageviewControl.view.bringSubviewToFront(pageControl)

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension tutorialPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex != 0 {
                // wrap to last page in array
                return self.pages[viewControllerIndex - 1]
            } /*else {
                // go to previous page in array
                return self.pages.last
            }*/
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } /*else {
                // wrap to first page in array
                pageControl.currentPageIndicatorTintColor = .white
            }*/
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                navigationItem.title = viewControllers[0].title
                    pageControl.currentPage = viewControllerIndex
                }
            }
    }
}
