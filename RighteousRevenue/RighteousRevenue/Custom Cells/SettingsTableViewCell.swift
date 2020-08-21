//
//  SettingsTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var indicatorImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setColorTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColorTheme(){
        contentView.theme_backgroundColor = GlobalPicker.cardColor
        settingName.theme_textColor = GlobalPicker.textColor
        indicatorImg.theme_tintColor = GlobalPicker.buttonTintColor
    }
    
}
