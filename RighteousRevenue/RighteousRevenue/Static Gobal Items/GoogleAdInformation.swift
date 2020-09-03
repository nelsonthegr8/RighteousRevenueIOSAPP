//
//  GoogleAdInformation.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/13/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import GoogleMobileAds
import UserMessagingPlatform

//public let globalTestDeviceID = "f832a6d30718bf1b9e619800e1173c6d"
//public let iphone7PlusTestAdID = "afb9cc4f32b22124511ee31e7f06dfbe"
//public let ipadTestAdID = "db273e6f48356c98dd4e9c4dc061cef9"
public let globalAddUnitID = "ca-app-pub-2613150010022550/7381214344"
public let debugTestID = "9FE2D18D-B91C-4548-9734-23029E451971"
private var addSections:GADBannerView!
private var addView:UIViewController!

public func addGoogleAdsToView(addSection: GADBannerView, view: UIViewController){
    addSections = addSection
    addView = view
    checkRequestParamaters()
}

private func checkRequestParamaters(){
    //Testing Purposes Only remove when done
//    UMPConsentInformation.sharedInstance.reset()
    // Create a UMPRequestParameters object.
    let parameters = UMPRequestParameters.init()
    // Set tag for under age of consent. Here NO means users are not under age.
    parameters.tagForUnderAgeOfConsent = false;
//    let debugSettings = UMPDebugSettings.init()
//    debugSettings.testDeviceIdentifiers = [debugTestID]
//    debugSettings.geography = UMPDebugGeography.EEA
//    parameters.debugSettings = debugSettings

    // Request an update to the consent information.
    DispatchQueue.main.async {
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { (error) in
            //The Consent Information has updated
            if(error != nil){
                
            }else {
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                if(formStatus == UMPFormStatus.available){
                    DispatchQueue.main.async(execute: loadForm)
                }
            }
            loadAds()
        }
    }
}

public func loadForm(){
    UMPConsentForm.load { (form, loadError) in
        if(loadError != nil){
            
        }else{
            if(UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained){
                loadAds()
            }
        }
    }
}

private func loadAds(){
    if(!UserDefaults.standard.bool(forKey: "UserPayed")){
        addSections.adUnitID = globalAddUnitID;
        addSections.rootViewController = addView;
        let addRequest = GADRequest()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
        [globalAddUnitID]; // Sample device ID
        addSections.load(addRequest)
        print(addSections.adSize)
    }else{
        addSections.removeConstraints(addSections.constraints)
        addSections.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}


