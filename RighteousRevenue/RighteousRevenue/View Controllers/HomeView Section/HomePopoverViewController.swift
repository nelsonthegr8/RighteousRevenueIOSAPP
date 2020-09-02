//
//  HomePopoverViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import SwiftTheme

class HomePopoverViewController: UIViewController {
    
//MARK: - Outlets
    @IBOutlet weak var sectionHeader: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
//MARK: - Variables
    var sectionName:String = "test"
    var sectionNumber:Int = 1
    var expenseCheck:Bool = false

//MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sectionHeader.text = sectionName
        setColorTheme()
    }

//MARK: - Segue Section
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "Add")
        {
            
            let vc = segue.destination as! AddViewController
            vc.Section = sectionNumber
            vc.SectionTitle = sectionName
            
        }else if(segue.identifier == "Edit")
        {
            
            let vc = segue.destination as! EditViewController
            vc.selectedSectionPresets.section = sectionNumber
            vc.selectedHeader = sectionName
            vc.expenseChecker = expenseCheck
            
        }
        
    }
    
//MARK: - Set Theme Section
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        sectionHeader.theme_textColor = GlobalPicker.textColor
        addButton.theme_setTitleColor(GlobalPicker.tabButtonTintColor, forState: .normal)
        editButton.theme_setTitleColor(GlobalPicker.tabButtonTintColor, forState: .normal)
        overrideUserInterfaceStyle = GlobalPicker.userInterfaceStyle[ThemeManager.currentThemeIndex]
    }
}
