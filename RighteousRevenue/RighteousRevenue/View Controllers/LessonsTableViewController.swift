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
    var index = 0
    
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
        cardsData.append(LessonCards( img: "cat", title: "Cat Gang", subheading: "dont get caught up in the", lesson: "Gang gang gang", videolink: "https://www.youtube.com/watch?v=2mgUPt2KI08&t=1s"))
        // Configure the cell...
        cell.configure(cardInfo: cardsData[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MoreInfo", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
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
        vc.finalYouTubeURL = cardsData[index].videolink
        vc.finalTitle = cardsData[index].title
        vc.finalDesc = cardsData[index].lesson
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}
