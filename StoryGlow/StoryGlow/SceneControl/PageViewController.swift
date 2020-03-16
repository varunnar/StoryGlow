//
//  PageViewController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/11/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import RxLifxApi
import RxLifx
import LifxDomain

class PageHolder: UIViewController {
    
    var storyIndex = Int()
    var currentSceneIndex = 0
    //bool to keep present mode
    var editModeNotification = Notification.Name("editMode") //notification if we are in edit more or present mode. Notificaion sent when segmented control changed
    struct editModeStruct {
        static var editMode = true
    }
    
    
    
    var pageControl =  UIPageControl()
    var pageviewControl = UIPageViewController()
    var pages = [UIViewController]()
    var addPageNotification = Notification.Name("addPage") //add page notification

    override func viewDidLoad() {
        self.title = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[currentSceneIndex].sceneName
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false //make sure the swiping in pageivewcontroller does not swipe back to tableviews and intropage
        setup()
        setupPageControl()
        pageviewControl.delegate = self
        pageviewControl.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(addPage), name: .some(addPageNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controlEditMode), name: .some(editModeNotification), object: nil)

        // Do any additional setup after loading the view.
    }
    
    //reset pageholder
    override func viewDidAppear(_ animated: Bool) {
        pages.removeAll() //remove wipe pages and reset them
        //rebuilding all pages in array of pageholder
        for i in 0...GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count-1{
            let NewPage = EnvironmentController()
            NewPage.sceneIndex = i
            NewPage.storyIndex = storyIndex
            pages.insert(NewPage, at: i)
        }
        //add in final page
        let finalPage = AddSceneViewController()
        pages.append(finalPage)
        print("currentscene")
        print(currentSceneIndex)
        pageviewControl.setViewControllers([pages[currentSceneIndex]], direction: .reverse, animated: false, completion: nil)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentSceneIndex
    }
    
    
    //add initial pages and setup pageviewcontroller
    func setup()
    {
        pageviewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let page1 = EnvironmentController()
        page1.sceneIndex = 0
        page1.storyIndex = 0
        let page2 = AddSceneViewController()
        pages.append(page1)
        pages.append(page2)
        addChild(pageviewControl)
        view.addSubview(pageviewControl.view)
        print("added as subview")
        pageviewControl.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageviewControl.view.frame = self.view.bounds
        pageviewControl.didMove(toParent: self)
        view.gestureRecognizers = pageviewControl.gestureRecognizers
    }
    
    //MARK: Setup and Contraints
    //setup pagecontrol which is the small navigational dots on the bottom of the screen
    func setupPageControl()
    {
        print("pagecontrol done")
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
    
    //MARK: Notification Functions
    
    //Function that is called when editmode notification is run. Toggles boolean
    @objc func controlEditMode(){
        //add case statement
        editModeStruct.editMode.toggle()
    }
    
    //Function that is called with addPage notification is run. Adds new environmentalcontroller and initializes story and scene indexes
    @objc func addPage()
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your new scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){ //if scene actually has name
            let scene = GlobalVar.Scenes(sceneName: answer!, colorVal: .white)
            GlobalVar.GlobalItems.storyArray[self.storyIndex].sceneArray.append(scene)
            self.title = answer
            let NewPage = EnvironmentController()
            NewPage.sceneIndex = self.pages.count-1
            NewPage.storyIndex = self.storyIndex
            self.pages.insert(NewPage, at: self.pages.count-1)
            self.pageviewControl.setViewControllers([self.pages[self.pages.count-2]], direction: .reverse, animated: true, completion: nil)
            self.pageControl.numberOfPages = self.pages.count
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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

//MARK: Extensions and Delegates

extension PageHolder: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            print("index backward \(viewControllerIndex)")
            print("in this function")
            if viewControllerIndex != 0 {
                // wrap to last page in array
                print("lookingback")
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
            print("index forward \(viewControllerIndex)")
            print("pages \(self.pages.count)")
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
    /*func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
            return pages.count
        }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
            let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {
                return 0
        }

        return firstViewControllerIndex
    }*/
    
}
