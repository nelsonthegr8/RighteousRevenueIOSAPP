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
        case help = "Help"
        case removeAds = "Remove Ads"
        case shop = "Shop"
        case about = "About"
        case contact = "Contact Us"
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingCell")
        tableView.delegate = self
        tableView.dataSource = self
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
        case .help:
            performSegue(withIdentifier: "Help", sender: self)
        case .removeAds:
            performSegue(withIdentifier: "RemoveAds", sender: self)
        case .shop:
            performSegue(withIdentifier: "Shop", sender: self)
        case .about:
            performSegue(withIdentifier: "About", sender: self)
        case .contact:
            performSegue(withIdentifier: "Contact", sender: self)
        }
    }
    
    
}

