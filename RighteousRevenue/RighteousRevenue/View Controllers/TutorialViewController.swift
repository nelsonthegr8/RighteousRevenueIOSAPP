//
//  TutorialViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, TutorialPageViewControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var skipButton: UIButton!
    
    //MARK: - Properties
    
    var tutorialPageViewController: TutorialPageViewController?
    var buttonsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nextButton.isHidden = buttonsVisible
        skipButton.isHidden = buttonsVisible
    }
    
    //MARK: - Actions
    
    @IBAction func skipButtonTapped(sender: UIButton){
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "FirstLaunch")
    }
    
    @IBAction func nextButtonTapped(sender: UIButton){
        
        if let index = tutorialPageViewController?.currentIndex{
            switch  index {
            case 0...1:
                tutorialPageViewController?.forwardPage()
            case 2:
                dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(false, forKey: "FirstLaunch")
                
            default: break
            }
        }
        
        updateUI()
    }
    
    //MARK: - View Controller life cycle
    func updateUI(){
        
        if let index = tutorialPageViewController?.currentIndex{
            switch index {
            case 0...1:
                if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
                    nextButton.setTitle("NEXT", for: .normal)
                    skipButton.isHidden = false
                }
                
            case 2:
                if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
                    nextButton.setTitle("Get Started", for: .normal)
                    skipButton.isHidden = true
                }
            default: break
            }
            
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? TutorialPageViewController {
            tutorialPageViewController = pageViewController
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
   

}
