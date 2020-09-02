//
//  LessonsTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import SwiftTheme

class LessonsTableViewCell: UITableViewCell {

    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var CardImg: UIImageView!
    @IBOutlet weak var CardTitle: UILabel!
    @IBOutlet weak var CardSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setCardThemeAndLayout),
            name: NSNotification.Name(rawValue: ThemeUpdateNotification),
            object: nil
        )
        setCardThemeAndLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(cardInfo: LessonCards)
    {
        CardImg.image = UIImage(named: cardInfo.img)
        CardTitle.text = cardInfo.title
        CardSubtitle.text = cardInfo.subheading
    }
    
    @objc func setCardThemeAndLayout() {
        contentView.theme_backgroundColor = GlobalPicker.backgroundColor
        CardView.theme_backgroundColor = GlobalPicker.cardColor
        CardTitle.theme_textColor = GlobalPicker.textColor
        CardSubtitle.theme_textColor = GlobalPicker.textColor
        CardView.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
        CardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        CardView.layer.shadowOpacity = 1.0
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 10.0
        CardImg.layer.cornerRadius = 5
        self.selectionStyle = .none
    }
    
}
