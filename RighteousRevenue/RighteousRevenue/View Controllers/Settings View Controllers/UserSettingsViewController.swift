//
//  UserSettingsViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/17/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import SwiftTheme
import TextFieldEffects

//MARK: - View Life Cycle
class UserSettingsViewController: UIViewController {
    
//MARK: - Outlets
    @IBOutlet var themeChoiceHeadertxtbx: UILabel!
    @IBOutlet var themeCollectionView: UICollectionView!
    @IBOutlet var monthlyIncomeTxtbx: YokoTextField!
    @IBOutlet var cardView: UIView!

//MARK: - Variables
    private var monthlyIncome = String(format: "%.02f",UserDefaults.standard.double(forKey: "UserMonthlyIncome"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setColorTheme()
        setUpCollectionView()
        monthlyIncomeTxtbx.delegate = self
        monthlyIncomeTxtbx.text = String(format: "%.02f",UserDefaults.standard.double(forKey: "UserMonthlyIncome"))
        monthlyIncomeTxtbx.addDoneCancelToolbar(onCancel: (target: self, action: #selector(cancelButtonTapped)) )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateThemeThatIsNotNative),
            name: NSNotification.Name(rawValue: ThemeUpdateNotification),
            object: nil
        )
    }
    
    
//MARK: - Set Color Theme
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        themeCollectionView.theme_backgroundColor = GlobalPicker.cardColor
        themeChoiceHeadertxtbx.theme_textColor = GlobalPicker.textColor
        updateThemeThatIsNotNative()
        setCardView()
    }
    
    func setCardView(){
        cardView.theme_backgroundColor = GlobalPicker.cardColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 10.0
    }
    
    @objc func updateThemeThatIsNotNative(){
        monthlyIncomeTxtbx.foregroundColor = GlobalPicker.textBoxBorderColor[ThemeManager.currentThemeIndex]
        monthlyIncomeTxtbx.placeholderColor = UIColor(named: GlobalPicker.aTextColor[ThemeManager.currentThemeIndex])!
        monthlyIncomeTxtbx.theme_textColor = GlobalPicker.textColor
        cardView.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
    }
}

//MARK: - Actions and Functions
extension UserSettingsViewController: UITextFieldDelegate{
    
    @objc func cancelButtonTapped() { monthlyIncomeTxtbx.resignFirstResponder(); monthlyIncomeTxtbx.text = monthlyIncome }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if(textField.text != nil && textField.text!.isDouble){
            UserDefaults.standard.set(Double(textField.text!), forKey: "UserMonthlyIncome")
        }else{
            textField.text = "*Please enter valid number"
            textField.textColor = expenseColor
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                self.updateThemeThatIsNotNative()
                textField.text = self.monthlyIncome
            }
        }
        
    }
    
}

//MARK: - Collection View Delegate and Data
extension UserSettingsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func setUpCollectionView(){
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeChooserCell", for: indexPath) as! UserSettingsCollectionViewCell
        
        cell.themeImg.image = UIImage(named: "cat")
        cell.themeImg.layer.borderWidth = 2
        if(indexPath.row == ThemeManager.currentThemeIndex){
            cell.themeImg.layer.borderColor = UIColor.blue.cgColor
        }else{
            cell.themeImg.layer.borderColor = GlobalPicker.textBoxBorderColor[indexPath.row].cgColor
        }
        
        cell.themeImg.layer.cornerRadius = 10
        cell.themeName.theme_textColor = GlobalPicker.textColor
        cell.themeName.text = themeNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MyThemes.switchTo(theme: MyThemes(rawValue: indexPath.row)!)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10, height: collectionView.frame.height - 4)
    }
    
}


