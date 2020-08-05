//
//  ShopCollectionViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/4/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var cardInfo: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
       
        
    }

}
