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
    @IBOutlet var containerView: UIView!
    
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
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
            CheckIfUserWantsNotifications()
        }
        nextButton.isHidden = buttonsVisible
        skipButton.isHidden = buttonsVisible
        setColorTheme()
    }
    
    //MARK: - Actions and Functions
    
    @IBAction func skipButtonTapped(sender: UIButton){
        UserDefaults.standard.set(false, forKey: "FirstLaunch")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButtonTapped(sender: UIButton){
        
        if let index = tutorialPageViewController?.currentIndex{
            switch  index {
            case 0...1:
                tutorialPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.set(false, forKey: "FirstLaunch")
                dismiss(animated: true, completion: nil)
            default: break
            }
             
        }
        
        updateUI()
    }
    
//MARK: - Function for setting up monthly alerts
    func CheckIfUserWantsNotifications(){
        
           let center = UNUserNotificationCenter.current()
           //first step give the person a choice to have monthly noties or not
               center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in
                
                if(granted){
                    DispatchQueue.main.async {
                        self.alertSystem(message: "Great You will be getting monthly reminders to get those bills payed! Currently The reminders are set for the first of every month. You can change it to the 15th of every month in the Settings area if you would like.")
                    }
                 
                }else{
                    DispatchQueue.main.async {
                        self.alertSystem(message: "At anytime you can go to user settings on your iphone and enable alerts to receive a monthly remider to pay your bills.")
                    }
                }
                
                DispatchQueue.main.async {
                    SetUpTheMonthlyNotification(day: 1)
                }
                
           })
           
       }
    
//MARK: - Alert System for Monthly Reminders
    func alertSystem(message: String){
        let alert = UIAlertController(title: "Righteous Revenue", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        containerView.theme_backgroundColor = GlobalPicker.backgroundColor
        pageControl.theme_pageIndicatorTintColor = GlobalPicker.cardColor
        pageControl.theme_currentPageIndicatorTintColor = GlobalPicker.tabButtonTintColor
    }

}
