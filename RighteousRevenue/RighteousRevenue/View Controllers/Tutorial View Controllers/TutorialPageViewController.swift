//
//  TutorialPageViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit


protocol TutorialPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    //MARK: - Properties
    
    weak var tutorialDelegate: TutorialPageViewControllerDelegate?
    
    var pageHeadings = ["God","Jesus","Cross"]
    var pageImages = ["onboarding-1","onboarding-2","onboarding-3"]
    var pageSubheadings = ["Loves You","Died For you","Is Where Jesus Payed The Price For Your Sin"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        // Create First Walkthrough Screen
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
   
    //MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         var index = (viewController as! TutorialContentViewController).index
         index += 1
         
         return contentViewController(at: index)
     }
    
    //MARK: - Content View Helper
    
    func contentViewController(at index: Int) -> TutorialContentViewController? {
        if index < 0 || index >= pageHeadings.count{
            return nil
        }
        
        // Create a new view controller and pass suitable data
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "TutorialContentViewController") as? TutorialContentViewController{
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubheadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    func forwardPage(){
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - Page View Controller Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let contentViewController = pageViewController.viewControllers?.first as? TutorialContentViewController{
                currentIndex = contentViewController.index
                
                tutorialDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }

}
