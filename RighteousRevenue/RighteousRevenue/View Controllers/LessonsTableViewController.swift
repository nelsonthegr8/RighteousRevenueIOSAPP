//
//  LessonsTableViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LessonsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSection: GADBannerView!
    var cardsData:[LessonCards] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGoogleAdsToView(addSection: addSection, view: self)
        initializeTableVIew()
        addSection.delegate = self
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonsTableCell", for: indexPath) as! LessonsTableViewCell
        cardsData.append(LessonCards(id: "0", img: "cat", title: "Cat Gang", description: "Gang gang gang"))
        // Configure the cell...
        cell.configure(cardInfo: cardsData[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MoreInfo", sender: self)
    }
    
    private func initializeTableVIew()
    {
        let nib = UINib(nibName: "LessonsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LessonsTableCell")
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LessonsMoreViewController
        vc.finalImg = cardsData[0].img
        vc.finalTitle = cardsData[0].title
        vc.finalDesc = cardsData[0].description
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}
