//
//  HomePopoverViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class HomePopoverViewController: UIViewController {

    @IBOutlet weak var sectionHeader: UILabel!
    var sectionName:String = "test"
    var sectionNumber:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sectionHeader.text = sectionName
        overrideUserInterfaceStyle = .dark
    }
    
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
        }
        
    }
    
    @IBAction func returnFromSelectedItemSegue(segue:UIStoryboardSegue){
        performSegue(withIdentifier: "returnFromPopUp", sender: nil)
    }
    
    func setColorTheme(){
        
    }
}
