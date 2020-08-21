//
//  AddEditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftTheme
import TextFieldEffects

extension String {
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil}
    var isDouble: Bool { return Double(self) != nil}
}

class AddViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableCardView: UIView!
    @IBOutlet weak var billNameTxtbx: JiroTextField!
    @IBOutlet weak var billAmountTxtbx: JiroTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var xButton: UIImageView!

//MARK: - Variables
    var idToDelete:[Int] = []
    public var Section: Int = 0
    public var SectionTitle: String = ""
    var sectionInfo: [MoreInfoForPieSection] = []
    let db = dataAccess()
    
}

//MARK: - Actions and Functions
extension AddViewController{
    
    @IBAction func xButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "returnHome", sender: dismiss(animated: true, completion: nil))
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        
        billAmountTxtbx.resignFirstResponder()
        billNameTxtbx.resignFirstResponder()
        
        if(inputValidation()){
            db.addUserInformation(input: UserSectionInput(section: Section, billName: billNameTxtbx.text!, billAmount: Double(billAmountTxtbx.text!)!))
            sectionInfo.append(MoreInfoForPieSection(billName: billNameTxtbx.text!, billAmount: Double(billAmountTxtbx.text!)!, symbol: ""))
            billAmountTxtbx.text = ""
            billNameTxtbx.text = ""
            billNameTxtbx.placeholder = "Bill Name"
            billAmountTxtbx.placeholder = "Bill Amount"
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
                self.setTextFieldTheme()
            }
            refreshAfterDBCall()
        }
        
    }

    @IBAction func editBtnPressed(_ sender: Any) {
        
        if(tableView.isEditing == false && sectionInfo.count != 0)
        {
            tableView.isEditing = true
            editBtn.setTitle( "Cancel", for: .normal)
        }else
        {
            if(idToDelete.count != 0){
                for item in idToDelete
                {
                    db.removeBillFromDB(ID: item)
                }

                refreshAfterDBCall()
                idToDelete.removeAll()
            }
            
            tableView.isEditing = false
            editBtn.setTitle( "Edit", for: .normal)
            
        }
        
    }
    
    func inputValidation() -> Bool{
        var result = true
        
        if(billNameTxtbx.text == ""){
            styleTextBox(txtBx: billNameTxtbx, message: "Enter expense name")
            result = false
        }else{billNameTxtbx.borderColor = UIColor(named: "IncomeColor")}
        
        if(billAmountTxtbx.text == "" || !billAmountTxtbx.text!.isDouble){
            styleTextBox(txtBx: billAmountTxtbx, message: "Enter expense amount")
            result = false
        }else{billAmountTxtbx.borderColor = UIColor(named: "IncomeColor")}
        
        return result
    }
    
    func styleTextBox(txtBx: JiroTextField, message: String){
        txtBx.borderColor = UIColor(named: "ExpenseColor")
        txtBx.text = ""
        txtBx.placeholder = "*" + message
    }
    
}
//MARK: - View Life Cycle And Color Theme
extension AddViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorTheme()
        addGoogleAdsToView(addSection: addSection, view: self)
        grabSectionInfo()
        setupTableView()
        setupTextboxDelegates()
        self.isModalInPresentation = true
        addSection.delegate = self
      }
    
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        titleTxt.theme_textColor = GlobalPicker.textColor
        tableView.theme_backgroundColor = GlobalPicker.cardColor
        sectionTitle.theme_textColor = GlobalPicker.textColor
        editBtn.theme_tintColor = GlobalPicker.tabButtonTintColor
        addBtn.theme_tintColor = GlobalPicker.tabButtonTintColor
        xButton.theme_tintColor = GlobalPicker.tabButtonTintColor
        setCardViews()
        setTextFieldTheme()
    }
    
    func setTextFieldTheme(){
        let textFieldsArr:[JiroTextField] = [billAmountTxtbx,billNameTxtbx]
        
        for txtBx in textFieldsArr{
            txtBx.borderColor = GlobalPicker.textBoxBorderColor[ThemeManager.currentThemeIndex]
            txtBx.placeholderColor = UIColor(named: GlobalPicker.aTextColor[ThemeManager.currentThemeIndex])!
            txtBx.theme_textColor = GlobalPicker.textColor
        }
    }
    
    func setCardViews(){
        let viewArr:[UIView] = [cardView,tableCardView]
        // Do any additional setup after loading the view.
        for cardview in viewArr{
            cardview.theme_backgroundColor = GlobalPicker.cardColor
            cardview.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
            cardview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cardview.layer.shadowOpacity = 1.0
            cardview.layer.masksToBounds = false
            cardview.layer.cornerRadius = 10.0
        }
    }
    
}

//MARK: - Table View Delegate and Data and Functions
extension AddViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            db.removeBillFromDB(ID: sectionInfo[indexPath.row].DataId)
            refreshAfterDBCall()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionInfo.count
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billsCell", for: indexPath) as! BillsSectionTableViewCell
        cell.billNameTxtbx.text = sectionInfo[indexPath.row].billName
        if(sectionInfo[0].symbol == "+"){
            cell.billAmountTxtbx.textColor = UIColor(named: "IncomeColor")
            cell.billAmountTxtbx.text = String(format: "+$%.02f",sectionInfo[indexPath.row].billAmount)
        }else{
            cell.billAmountTxtbx.textColor = UIColor(named: "ExpenseColor")
            cell.billAmountTxtbx.text = String(format: "-$%.02f",sectionInfo[indexPath.row].billAmount)
        }
        //
        cell.payedCheckbx.tag = sectionInfo[indexPath.row].DataId
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.isEditing){
            idToDelete.append(sectionInfo[indexPath.row].DataId)
            editBtn.setTitle("Delete", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for item in idToDelete.indices
        {
            if(idToDelete[item] == sectionInfo[indexPath.row].DataId)
            {
                idToDelete.remove(at: item)
                break;
            }
        }
        if(idToDelete.indices.isEmpty)
        {
            editBtn.setTitle("Cancel", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        grabSectionInfo()
        let cell = cell as! BillsSectionTableViewCell
        cell.payedCheckbx.on = sectionInfo[indexPath.row].payed
        if(cell.payedCheckbx.on){
            cell.payedTxtUnderneath.textColor = incomeColor
        }else{
            cell.payedTxtUnderneath.theme_textColor = GlobalPicker.buttonTintColor
        }
    }
    
    // Function That Sets Up the table view Delegate and Data Source
    func setupTableView(){
        let nib = UINib(nibName: "BillsSectionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "billsCell")
        tableView.delegate = self
        tableView.dataSource = self
        sectionTitle.text = SectionTitle
    }
    
    func refreshAfterDBCall(){
        grabSectionInfo()
        tableView.reloadData()
    }
    
    func grabSectionInfo(){
        sectionInfo = db.grabMoreInfoForSection(Section: Section)
    }
    
}

//MARK: - Text Field Delegate
extension AddViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func setupTextboxDelegates(){
        billAmountTxtbx.delegate = self
        billNameTxtbx.delegate = self
        billAmountTxtbx.addDoneCancelToolbar()
    }
}

//MARK: - Google Admob Delegate
extension AddViewController: GADBannerViewDelegate{
    //set fade in style for ad on load
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
}

