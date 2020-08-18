//
//  EditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EditViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, GADBannerViewDelegate{
    
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var sectionHeaderTxtxbx: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var googleAddSection: GADBannerView!
    @IBOutlet weak var sectionColorLbl: UILabel!
    @IBOutlet weak var sectionIconLbl: UILabel!
    @IBOutlet weak var sectionColorImg: UIImageView!
    @IBOutlet weak var sectionIconImg: UIImageView!
    
    
    
    var selectedSectionPresets:IconChoice = IconChoice(iconID: 1, section: 1, iconName: "", sectionColor: "")
    var selectedHeader: String = ""
    private var userSelectedRow:Int = 1
    let db = dataAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Ads.
        addGoogleAdsToView(addSection: googleAddSection, view: self)
        //Setup the header text
        headerTxt.text = selectedHeader
        sectionHeaderTxtxbx.text = selectedHeader
        //Get and set the styles
        getStylePresetsFromDB()
        setTextAndColors()
        //setup the card view
        setCardView()
        //assign delegates and modal presentation for popup
        self.isModalInPresentation = true
        googleAddSection.delegate = self
        sectionHeaderTxtxbx.delegate = self
    }
    
    func setTextAndColors(){
        sectionColorLbl.text = sectionHeaderTxtxbx.text! + " Color"
        sectionIconLbl.text = sectionHeaderTxtxbx.text! + " Icon"
        sectionColorImg.backgroundColor = UIColor(named: selectedSectionPresets.sectionColor)
        sectionIconImg.image = UIImage(named: selectedSectionPresets.iconName)
    }
    
    func getStylePresetsFromDB(){
        selectedSectionPresets = db.getIconForSection(Section: selectedSectionPresets.section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "viewColorMore" || segue.identifier == "viewIconsMore" ){
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
        setTextAndColors()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "returnHome", sender: dismiss(animated: true, completion: nil))
    }
    
    @IBAction func tappedColorStack(_ sender: Any) {
        userSelectedRow = 1
        performSegue(withIdentifier: "viewColorMore", sender: nil)
    }
    
    @IBAction func tappedIconStack(_ sender: Any) {
        userSelectedRow = 2
        performSegue(withIdentifier: "viewIconsMore", sender: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sectionHeaderTxtxbx.text = sectionHeaderTxtxbx.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        db.updatePieCustomization(type: 3, section: selectedSectionPresets.section, item: sectionHeaderTxtxbx.text!)
        headerTxt.text = sectionHeaderTxtxbx.text!
        setTextAndColors()
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
    
    func setColorTheme(){
        
    }
}
