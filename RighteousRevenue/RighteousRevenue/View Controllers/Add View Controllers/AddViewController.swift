//
//  AddEditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension String {
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil}
    var isDouble: Bool { return Double(self) != nil}
}

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GADBannerViewDelegate {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableCardView: UIView!
    @IBOutlet weak var billNameTxtbx: UITextField!
    @IBOutlet weak var billAmountTxtbx: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var editBtn: UIButton!
    var idToDelete:[Int] = []
    public var Section: Int = 0
    public var SectionTitle: String = ""
    var sectionInfo: [MoreInfoForPieSection] = []
    let db = dataAccess()
    
    @IBAction func xButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "returnHome", sender: dismiss(animated: true, completion: nil))
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        billAmountTxtbx.resignFirstResponder()
        billNameTxtbx.resignFirstResponder()
        
        if(inputValidation()){
            db.addUserInformation(input: UserSectionInput(section: Section, billName: billNameTxtbx.text!, billAmount: Double(billAmountTxtbx.text!)!))
            sectionInfo.append(MoreInfoForPieSection(billName: billNameTxtbx.text!, billAmount: Double(billAmountTxtbx.text!)!))
            billAmountTxtbx.text = ""
            billNameTxtbx.text = ""
            refreshAfterDBCall()
        }
        
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        if(tableView.isEditing == false)
        {
            tableView.isEditing = true
            editBtn.setTitle( "Cancel", for: .normal)
        }else
        {
            for item in idToDelete
            {
                db.removeBillFromDB(ID: item)
            }

            refreshAfterDBCall()
            idToDelete.removeAll()
            tableView.isEditing = false
            editBtn.setTitle( "Edit", for: .normal)
        }
    }
    
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
        cell.billAmountTxtbx.text = String(format: "$%.02f",sectionInfo[indexPath.row].billAmount)
        cell.payedCheckbx.on = sectionInfo[indexPath.row].payed
        cell.payedCheckbx.tag = sectionInfo[indexPath.row].DataId
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idToDelete.append(sectionInfo[indexPath.row].DataId)
        editBtn.setTitle("Delete", for: .normal)
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
    
    func setCardViews(){
        let viewArr:[UIView] = [cardView,tableCardView]
        // Do any additional setup after loading the view.
        for view in viewArr{
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            view.layer.shadowOpacity = 1.0
            view.layer.masksToBounds = false
            view.layer.cornerRadius = 10.0
        }
    }
    
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
    
    func inputValidation() -> Bool{
        var result = true
        
        if(billNameTxtbx.text == ""){
            styleTextBox(txtBx: billNameTxtbx, message: "Enter expense name")
            result = false
        }else{billNameTxtbx.backgroundColor = UIColor.green}
        
        if(billAmountTxtbx.text == "" || !billAmountTxtbx.text!.isDouble){
            styleTextBox(txtBx: billAmountTxtbx, message: "Enter valid expense amount")
            result = false
        }else{billAmountTxtbx.backgroundColor = UIColor.green}
        
        return result
    }
    
    func styleTextBox(txtBx: UITextField, message: String){
        txtBx.backgroundColor = UIColor.red
        txtBx.text = ""
        txtBx.placeholder = "*" + message
    }
    
    func setupTextboxDelegates(){
        billAmountTxtbx.delegate = self
        billNameTxtbx.delegate = self
        billAmountTxtbx.addDoneCancelToolbar()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //let specialChars = CharacterSet(charactersIn: "$")
        //billAmountTxtbx.text = billAmountTxtbx.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        billNameTxtbx.text = billNameTxtbx.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        //if(textField.tag == 2){
          //  billAmountTxtbx.text = billAmountTxtbx.text?.trimmingCharacters(in: specialChars)
        //}
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
}
//MARK: - View Life Cycle
extension AddViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorTheme()
        addGoogleAdsToView(addSection: addSection, view: self)
        setCardViews()
        grabSectionInfo()
        setupTableView()
        setupTextboxDelegates()
        self.isModalInPresentation = true
        addSection.delegate = self
      }
    
    func setColorTheme(){
        
    }
}

