//
//  AtmBillInfoCollectionViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 11/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import BEMCheckBox

class AtmBillInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var billNamelbl: UILabel!{
        didSet{
            billNamelbl.theme_textColor = GlobalPicker.textColor
            contentView.theme_backgroundColor = GlobalPicker.backgroundColor
        }
    }
    @IBOutlet var billPricelbl: UILabel!{
        didSet{
            billPricelbl.theme_textColor = GlobalPicker.textColor
        }
    }
    @IBOutlet var rowChkbx: BEMCheckBox!{
        didSet{
            rowChkbx.theme_backgroundColor = GlobalPicker.backgroundColor
            rowChkbx.theme_tintColor = GlobalPicker.cardColor
            rowChkbx.onTintColor = incomeColor
            rowChkbx.onCheckColor = incomeColor
        }
    }
    
}
