//
//  AddEditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var billNameTxtbx: UITextField!
    @IBOutlet weak var billAmountTxtbx: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 10.0
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
    }
    
}
