//
//  TutorialContentViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var headinglabel: UILabel!{
        didSet{
            headinglabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel!{
        didSet{
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentImageView: UIImageView!
    
    // MARK: - Properties
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headinglabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
        setupColorTheme()
    }
    
    //MARK: - Set Color Theme
    
    private func setupColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        headinglabel.theme_textColor = GlobalPicker.textColor
        subHeadingLabel.theme_textColor = GlobalPicker.textColor
    }
}
