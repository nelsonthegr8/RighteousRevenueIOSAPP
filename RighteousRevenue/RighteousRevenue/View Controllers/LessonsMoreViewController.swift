//
//  LessonsMoreViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds
import YouTubePlayer

class LessonsMoreViewController: UIViewController,GADBannerViewDelegate, YouTubePlayerDelegate {

    @IBOutlet weak var YoutubeVideo: YouTubePlayerView!
    @IBOutlet weak var MoreInfoTitle: UILabel!
    @IBOutlet weak var MoreInfoDescription: UITextView!
    @IBOutlet weak var addSection: GADBannerView!
    
    var finalYouTubeURL:String = ""
    var finalTitle: String = ""
    var finalDesc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addGoogleAdsToView(addSection: addSection, view: self)
        let myVideoURL = URL(string: finalYouTubeURL)!
        YoutubeVideo.delegate = self
        YoutubeVideo.loadVideoURL(myVideoURL)
        MoreInfoTitle.text = finalTitle
        MoreInfoDescription.text = finalDesc
        addSection.delegate = self
    }
    
    @IBAction func closeBtnPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
}
