//
//  GoogleAdInformation.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/13/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import GoogleMobileAds

public let globalAddUnitID = "ca-app-pub-2613150010022550/7381214344"

public func addGoogleAdsToView(addSection: GADBannerView, view: UIViewController){
    if(!UserDefaults.standard.bool(forKey: "UserPayed")){
        addSection.adUnitID = globalAddUnitID;
        addSection.rootViewController = view;
        let addRequest = GADRequest()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
        [globalAddUnitID]; // Sample device ID
        addSection.load(addRequest)
        print(addSection.adSize)
    }else{
        addSection.removeConstraints(addSection.constraints)
        addSection.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

