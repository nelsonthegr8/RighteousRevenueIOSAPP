//
//  UserSettingsViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/17/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func one(_ sender: Any) {
        if(UserDefaults.standard.string(forKey: "ThemeChoice") == "Dark"){
            UserDefaults.standard.set("Light", forKey: "ThemeChoice")
            
        }else{
            UserDefaults.standard.set("Dark", forKey: "ThemeChoice")
        }
    }
    
    @IBAction func two(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "UserPayed") == true){
            UserDefaults.standard.set(false, forKey: "UserPayed")
        }else{
            UserDefaults.standard.set(true, forKey: "UserPayed")
        }
    }
    
    func setColorTheme(){
        
    }
}
