//
//  EditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftTheme
import TextFieldEffects

class EditViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, GADBannerViewDelegate{
//MARK: - Outlets
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var sectionHeaderTxtxbx: YokoTextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var googleAddSection: GADBannerView!
    @IBOutlet weak var sectionColorLbl: UILabel!
    @IBOutlet weak var sectionIconLbl: UILabel!
    @IBOutlet weak var sectionColorImg: UIImageView!
    @IBOutlet weak var sectionIconImg: UIImageView!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var expenseSwitch: UISwitch!
    @IBOutlet weak var xButton: UIImageView!
    
//MARK: - Variables
    
    var selectedSectionPresets:IconChoice = IconChoice(iconID: 1, section: 1, iconName: "", sectionColor: "")
    var selectedHeader: String = ""
    var expenseChecker: Bool = false
    private var userSelectedRow:Int = 1
    let db = dataAccess()
    
//MARK: - View Life Cylcle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Ads.
        addGoogleAdsToView(addSection: googleAddSection, view: self)
        //Setup the header text and Switch
        headerTxt.text = selectedHeader
        sectionHeaderTxtxbx.text = selectedHeader
        expenseSwitch.isOn = expenseChecker
        //Get and set the styles
        getStylePresetsFromDB()
        setTextAndColors()
        //setup the card view and color theme
        setColorTheme()
        setCardView()
        //assign delegates and modal presentation for popup
        self.isModalInPresentation = true
        googleAddSection.delegate = self
        sectionHeaderTxtxbx.delegate = self
    }

//MARK: - Functions
    func setTextAndColors(){
        sectionColorLbl.text = sectionHeaderTxtxbx.text! + " Color"
        sectionIconLbl.text = sectionHeaderTxtxbx.text! + " Icon"
        sectionColorImg.backgroundColor = UIColor(named: selectedSectionPresets.sectionColor)
        sectionIconImg.image = UIImage(named: selectedSectionPresets.iconName)
    }

//MARK: - Segue Section
    func getStylePresetsFromDB(){
        selectedSectionPresets = db.getIconForSection(Section: selectedSectionPresets.section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "viewColorMore" || segue.identifier == "viewIconsMore" ){
            if(sectionHeaderTxtxbx.isFirstResponder){
                sectionHeaderTxtxbx.resignFirstResponder()
            }
            let vc = segue.destination as! UserPresetViewMoreViewController
            vc.selectedSection = userSelectedRow
            vc.pieSectionID = selectedSectionPresets.section
            vc.popoverPresentationController?.delegate = self
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
//MARK: - Actions
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
    
    @IBAction func expenseSwitchClicked(_ sender: UISwitch) {
        if(expenseSwitch.isOn){
            expenseChecker = true
            db.updatePieCustomization(type: 4, section: selectedSectionPresets.section, item: "-")
        }else{
            expenseChecker = false
            db.updatePieCustomization(type: 4, section: selectedSectionPresets.section, item: "+")
        }
    }
    
//MARK: - Text Field Delegate
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

//MARK: - Google Ad Delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }

//MARK: - Set Color Themes
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        xButton.theme_tintColor = GlobalPicker.tabButtonTintColor
        headerTxt.theme_textColor = GlobalPicker.textColor
        sectionHeaderTxtxbx.foregroundColor = GlobalPicker.textBoxBorderColor[ThemeManager.currentThemeIndex]
        sectionHeaderTxtxbx.placeholderColor = UIColor(named: GlobalPicker.aTextColor[ThemeManager.currentThemeIndex])!
        cardView.theme_backgroundColor = GlobalPicker.cardColor
        sectionColorLbl.theme_textColor = GlobalPicker.textColor
        sectionIconLbl.theme_textColor = GlobalPicker.textColor
        expenseLbl.theme_textColor = GlobalPicker.textColor
        expenseSwitch.theme_backgroundColor = GlobalPicker.cardColor
        expenseSwitch.theme_thumbTintColor = GlobalPicker.backgroundColor
        expenseSwitch.theme_onTintColor = GlobalPicker.tabButtonTintColor
        sectionIconImg.theme_tintColor = GlobalPicker.tabButtonTintColor
    }
    
    func setCardView(){
        cardView.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
           cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
           cardView.layer.shadowOpacity = 1.0
           cardView.layer.masksToBounds = false
           cardView.layer.cornerRadius = 10.0
       }
}
