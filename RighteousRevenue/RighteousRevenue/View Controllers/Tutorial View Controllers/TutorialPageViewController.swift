//
//  TutorialPageViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import SwiftTheme

protocol TutorialPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    //MARK: - Properties
    
    weak var tutorialDelegate: TutorialPageViewControllerDelegate?
    
    var pageHeadings = ["Monthly Budget Pie Chart","Daily Scriptures","Pie chart Options","Add to Pie Chart","Entry View","Keep Track"]
    
    var pageSubheadings = [
        "The sections of the pie chart are used to put your expenses and savings in sections. Keep your budget Organized.","Sciptures are tappable they navigate you to the scripture in the Bible. Have God's Word be a guide to your heart towards finance.","Have the ability to add entries to the sections in the pie chart and customize the color, icon, section name, and choose if it is an expense or not.","Add your entries to the pie chart and it will be saved right to your phone!","View and edit your entries in this area. Delete multiple entries with the edit button or remove an entry with the swipe of a finger","Keep Track of your payments per month by tapping the payed button!"]
    
    var pageImages:[[String]] = [
        ["LightTutorial 1","LightTutorial 2","LightTutorial 3","LightTutorial 4","LightTutorial 5","LightTutorial 6"],
        ["DarkTutorial 1","DarkTutorial 2","DarkTutorial 3","DarkTutorial 4","DarkTutorial 5","DarkTutorial 6"]
    ]
    
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
            pageContentViewController.imageFile = pageImages[ThemeManager.currentThemeIndex][index]
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
