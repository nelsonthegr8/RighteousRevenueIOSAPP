//
//  EditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, GADBannerViewDelegate{
    
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionHeaderTxtxbx: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var googleAddSection: GADBannerView!
    
    
    var selectedSectionPresets:IconChoice = IconChoice(iconID: 1, section: 1, iconName: "", sectionColor: "")
    var selectedHeader: String = ""
    private var userSelectedRow:Int = 0
    let db = dataAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addGoogleAdsToView(addSection: googleAddSection, view: self)
        sectionHeaderTxtxbx.delegate = self
        getStylePresetsFromDB()
        setUpTable()
        setCardView()
        headerTxt.text = selectedHeader
        sectionHeaderTxtxbx.text = selectedHeader
        self.isModalInPresentation = true
        googleAddSection.delegate = self
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
            vc.pieSectionID = selectedSectionPresets.section
            vc.popoverPresentationController?.delegate = self
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func setCardView(){
        
            cardView.layer.shadowColor = UIColor.gray.cgColor
            cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cardView.layer.shadowOpacity = 1.0
            cardView.layer.masksToBounds = false
            cardView.layer.cornerRadius = 10.0
        
    }
    
    @IBAction func returnFromViewMoreSegue(segue:UIStoryboardSegue){
        getStylePresetsFromDB()
        tableView.reloadData()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "returnHome", sender: dismiss(animated: true, completion: nil))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sectionHeaderTxtxbx.text = sectionHeaderTxtxbx.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        db.updatePieCustomization(type: 3, section: selectedSectionPresets.section, item: sectionHeaderTxtxbx.text!)
        headerTxt.text = sectionHeaderTxtxbx.text!
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
}
