//
//  LessonsTableViewCell.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class LessonsTableViewCell: UITableViewCell {

    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var CardImg: UIImageView!
    @IBOutlet weak var CardTitle: UILabel!
    @IBOutlet weak var CardSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(cardInfo: LessonCards)
    {
        CardImg.image = UIImage(named: cardInfo.img)
        CardTitle.text = cardInfo.title
        CardSubtitle.text = cardInfo.description
        
        CardView.layer.shadowColor = UIColor.gray.cgColor
        CardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        CardView.layer.shadowOpacity = 1.0
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 2.0
        //self.selectionStyle = .none
    }
    
}
