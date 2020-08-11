//
//  EditTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
