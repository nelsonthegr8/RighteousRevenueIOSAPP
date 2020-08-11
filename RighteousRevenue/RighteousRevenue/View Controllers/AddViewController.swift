//
//  AddEditViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/5/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableCardView: UIView!
    @IBOutlet weak var billNameTxtbx: UITextField!
    @IBOutlet weak var billAmountTxtbx: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionTitle: UILabel!
    public var Section: Int = 0
    public var SectionTitle: String = ""
    var sectionInfo: [MoreInfoForPieSection] = []
    let db = dataAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardViews()
        grabSectionInfo()
        setupTableView()
    }
  
    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        db.addUserInformation(input: UserSectionInput(section: Section, billName: "Tester", billAmount: 200.43))
        sectionInfo.append(MoreInfoForPieSection(billName: "Tester", billAmount: 200.43))
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionInfo.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billsCell", for: indexPath) as! BillsSectionTableViewCell
        cell.billNameTxtbx.text = sectionInfo[indexPath.row].billName
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
        sectionTitle.text = SectionTitle
    }
    
    func grabSectionInfo(){
        sectionInfo = db.grabMoreInfoForSection(Section: Section)
    }
    
}
