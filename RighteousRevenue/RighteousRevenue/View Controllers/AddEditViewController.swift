//
//  AddEditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableCardView: UIView!
    @IBOutlet weak var billNameTxtbx: UITextField!
    @IBOutlet weak var billAmountTxtbx: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardViews()
        setupTableView()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          30
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billsCell", for: indexPath) as! BillsSectionTableViewCell
        
        return cell
      }
    
    func setCardViews(){
        let viewArr:[UIView] = [cardView,tableCardView]
        // Do any additional setup after loading the view.
        for view in viewArr{
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            view.layer.shadowOpacity = 1.0
            view.layer.masksToBounds = false
            view.layer.cornerRadius = 10.0
        }
    }
    
    func setupTableView(){
        let nib = UINib(nibName: "BillsSectionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "billsCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
