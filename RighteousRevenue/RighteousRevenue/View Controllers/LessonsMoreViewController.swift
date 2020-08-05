//
//  LessonsMoreViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class LessonsMoreViewController: UIViewController {

    @IBOutlet weak var MoreInfoImg: UIImageView!
    @IBOutlet weak var MoreInfoTitle: UILabel!
    @IBOutlet weak var MoreInfoDescription: UITextView!
    
    var finalImg:String = ""
    var finalTitle: String = ""
    var finalDesc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MoreInfoImg.image = UIImage(named: finalImg)
        MoreInfoTitle.text = finalTitle
        MoreInfoDescription.text = finalDesc
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        
    }
    @IBAction func closeBtnPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupHero(info: LessonCards){
              finalImg = info.img
              finalTitle = info.title
              finalDesc = info.description
    }
}
