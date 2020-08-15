//
//  BillsSectionTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/6/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import BEMCheckBox

class BillsSectionTableViewCell: UITableViewCell, BEMCheckBoxDelegate {

    @IBOutlet weak var billNameTxtbx: UILabel!
    @IBOutlet weak var billAmountTxtbx: UILabel!
    @IBOutlet weak var payedCheckbx: BEMCheckBox!
    let db = dataAccess()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtnAnimations()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if(checkBox.on){
            db.updateUserPayed(payed: checkBox.on, ID: checkBox.tag)
        }else{
            db.updateUserPayed(payed: checkBox.on, ID: checkBox.tag)
        }
    }
    
    func setButtnAnimations(){
        payedCheckbx.delegate = self
        payedCheckbx.onAnimationType = .fill
        payedCheckbx.offAnimationType = .oneStroke
        payedCheckbx.animationDuration = 0.6
    }
    
}
