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
import NVActivityIndicatorView

class LessonsMoreViewController: UIViewController,GADBannerViewDelegate, YouTubePlayerDelegate {
    
//MARK: - Outlets
    @IBOutlet weak var YoutubeVideo: YouTubePlayerView!
    @IBOutlet weak var MoreInfoTitle: UILabel!
    @IBOutlet weak var MoreInfoDescription: UITextView!
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var internetDisconectedView: UIImageView!
    @IBOutlet weak var xButton: UIImageView!
    @IBOutlet weak var loadingVideo: NVActivityIndicatorView!
    
//MARK: - Variables
    var finalYouTubeURL:String = ""
    var finalTitle: String = ""
    var finalDesc: String = ""
    
//MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Google Ad.
        addGoogleAdsToView(addSection: addSection, view: self)
        addSection.delegate = self
        //set color theme
        setColorTheme()
        //Check if user has internet to load youtube video
        if(CheckInternet.Connection()){
            internetDisconectedView.isHidden = true
            loadingVideo.startAnimating()
            let myVideoURL = URL(string: finalYouTubeURL)!
            YoutubeVideo.delegate = self
            YoutubeVideo.loadVideoURL(myVideoURL)
        }else{
            loadingVideo.isHidden = true
        }
        //set up final text to display to user title and lesson information
        MoreInfoTitle.text = finalTitle
        MoreInfoDescription.text = finalDesc
    }

//MARK: - Actions
    @IBAction func closeBtnPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK: - Google Ad Delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
//MARK: - You Tube Player Delegate
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        loadingVideo.stopAnimating()
    }
    
//MARK: - Set Theme Section
    func setColorTheme(){
        MoreInfoTitle.theme_textColor = GlobalPicker.textColor
        MoreInfoDescription.theme_textColor = GlobalPicker.textColor
        MoreInfoDescription.theme_backgroundColor = GlobalPicker.backgroundColor
        internetDisconectedView.theme_tintColor = GlobalPicker.buttonTintColor
        loadingVideo.theme_tintColor = GlobalPicker.buttonTintColor
        xButton.theme_tintColor = GlobalPicker.buttonTintColor
        view.theme_backgroundColor = GlobalPicker.backgroundColor
    }
    
}
