//
//  BillsSectionTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/6/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import BEMCheckBox
import SwiftTheme

class BillsSectionTableViewCell: UITableViewCell, BEMCheckBoxDelegate {

    @IBOutlet weak var billNameTxtbx: UILabel!
    @IBOutlet weak var billAmountTxtbx: UILabel!
    @IBOutlet weak var payedCheckbx: BEMCheckBox!
    @IBOutlet weak var payedTxtUnderneath: UILabel!
    let db = dataAccess()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtnAnimations()
        setTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.theme_backgroundColor = GlobalPicker.backgroundColor
        if(selected){
            let bgColorView = UIView()
            bgColorView.theme_backgroundColor = GlobalPicker.backgroundColor
            selectedBackgroundView = bgColorView
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.theme_tintColor = GlobalPicker.cardColor
        
    }
//MARK: - Set bill payed Checked
    func didTap(_ checkBox: BEMCheckBox) {
        if(checkBox.on){
            db.updateUserPayed(payed: checkBox.on, ID: checkBox.tag)
            setOnTintColor()
        }else{
            db.updateUserPayed(payed: checkBox.on, ID: checkBox.tag)
            setOnTintColor()
        }
    }
    
//MARK: - Set Button Animations
    func setButtnAnimations(){
        payedCheckbx.delegate = self
        payedCheckbx.onAnimationType = .fill
        payedCheckbx.offAnimationType = .oneStroke
        payedCheckbx.animationDuration = 0.6
    }
    
//MARK: - Set Theme
    func setTheme(){
        contentView.theme_backgroundColor = GlobalPicker.cardColor
        billNameTxtbx.theme_textColor = GlobalPicker.textColor
        payedCheckbx.theme_backgroundColor = GlobalPicker.cardColor
        payedCheckbx.theme_tintColor = GlobalPicker.backgroundColor
        payedCheckbx.onTintColor = incomeColor
        payedCheckbx.onCheckColor = incomeColor
        setOnTintColor()
    }
    
    func setOnTintColor(){
        
        if(payedCheckbx.on){
            payedTxtUnderneath.textColor = incomeColor
        }else{
            payedTxtUnderneath.theme_textColor = GlobalPicker.buttonTintColor
        }
        
    }
    
}
