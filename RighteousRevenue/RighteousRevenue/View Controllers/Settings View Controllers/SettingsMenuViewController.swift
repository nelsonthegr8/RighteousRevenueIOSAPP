//
//  SideMenu.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UIKit

class SettingsMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private enum menuItems: String, CaseIterable{
        case userSettings = "User Settings"
        case help = "Help"
        case contact = "Contact Us"
        case removeAds = "Remove Ads"
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var defaultTheme = UserDefaults.standard.string(forKey: "ThemeChoice")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: "ThemeChoice") != defaultTheme){
            setColorTheme()
            viewDidLoad()
            defaultTheme = UserDefaults.standard.string(forKey: "ThemeChoice")
        }
    }

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Help"){
            let viewController = segue.destination as! TutorialViewController
            viewController.buttonsVisible = true
        }
    }
    
    func setColorTheme(){
      
    }
    
}

