//
//  EditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionHeaderTxtxbx: UITextField!
    var selectedSectionPresets:IconChoice = IconChoice(iconID: 1, section: 1, iconName: "", sectionColor: "")
    var selectedHeader: String = ""
    private var userSelectedRow:Int = 0
    let db = dataAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStylePresetsFromDB()
        setUpTable()
        headerTxt.text = selectedHeader
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    //set style for the two cells either for the color or the icon since there are only two sections i have them hard coded
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPieSectionCell", for: indexPath) as! EditTableViewCell
        
        if(indexPath.row == 0){
            cell.title.text = headerTxt.text! + " Color"
            cell.img.backgroundColor = UIColor(named: selectedSectionPresets.sectionColor)
        }else{
            cell.title.text = headerTxt.text! + " Icon"
            cell.img.image = UIImage(named: selectedSectionPresets.iconName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userSelectedRow = indexPath.row + 1
        performSegue(withIdentifier: "viewMore", sender: nil)
    }
    
    func setUpTable(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getStylePresetsFromDB(){
        selectedSectionPresets = db.getIconForSection(Section: selectedSectionPresets.section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "viewMore"){
            let vc = segue.destination as! UserPresetViewMoreViewController
            vc.selectedSection = userSelectedRow
            vc.popoverPresentationController?.delegate = self
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func returnFromSegue(){
        getStylePresetsFromDB()
        tableView.reloadData()
    }
    
}
