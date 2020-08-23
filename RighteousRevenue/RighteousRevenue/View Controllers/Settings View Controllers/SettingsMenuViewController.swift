//
//  SideMenu.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UIKit

class SettingsMenuController: UIViewController{
    
//MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionNumber: UILabel!
    
//MARK: - Variables
    private enum menuItems: String, CaseIterable{
          case userSettings = "User Settings"
          case help = "Help"
          case contact = "Contact Us"
          case removeAds = "Remove Ads"
      }
    
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"
    
//MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set color scheme
        setColorTheme()
        //set version Number
        versionNumber.text = getVersion()
        //register table view 
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    

//MARK: - Segue Section
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Help"){
            let viewController = segue.destination as! TutorialViewController
            viewController.buttonsVisible = true
        }
    }
    
//MARK: - Set Color Theme
    func setColorTheme(){
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_separatorColor = GlobalPicker.cardColor
        versionNumber.theme_textColor = GlobalPicker.textColor
    }
    
//MARK: - Get Current Version Number
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        let build = dictionary[kBuildNumber] as! String
        
        return "App version \(version)(\(build))"
    }
}

//MARK: - Table View Delegate And Data
extension SettingsMenuController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return menuItems.allCases.count
       }
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsTableViewCell
           
           cell.settingName.text = menuItems.allCases[indexPath.row].rawValue
           
           return cell
       }
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Relay to delegate about menu item selection
           let selectedItem = menuItems.allCases[indexPath.row]
           switch selectedItem{
           case .userSettings:
           performSegue(withIdentifier: "UserSettings", sender: self)
           tableView.deselectRow(at: indexPath, animated: false)
           case .help:
               performSegue(withIdentifier: "Help", sender: self)
               tableView.deselectRow(at: indexPath, animated: false)
           case .contact:
               performSegue(withIdentifier: "ContactUs", sender: self)
               tableView.deselectRow(at: indexPath, animated: false)
           case .removeAds:
               performSegue(withIdentifier: "RemoveAds", sender: self)
               tableView.deselectRow(at: indexPath, animated: false)
           }
       }
    
}
