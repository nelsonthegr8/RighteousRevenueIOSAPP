//
//  SideMenu.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class SettingsMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver{
    
    private enum menuItems: String, CaseIterable{
        case help = "Help"
        case removeAds = "Remove Ads"
        case shop = "Shop"
        case about = "About"
        case contact = "Contact Us"
    }
    
    var myProduct: SKProduct?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchProducts()
    }
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.allCases.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsTableViewCell
        cell.settingName.text = menuItems.allCases[indexPath.row].rawValue
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Relay to delegate about menu item selection
        let selectedItem = menuItems.allCases[indexPath.row]
        switch selectedItem{
        case .help:
            performSegue(withIdentifier: "Help", sender: self)
        case .removeAds:
            guard let myProduct = myProduct else{return}
            
            if SKPaymentQueue.canMakePayments(){
                let payment = SKPayment(product: myProduct)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
            
            break
        case .shop:
            performSegue(withIdentifier: "Shop", sender: self)
        case .about:
            performSegue(withIdentifier: "About", sender: self)
        case .contact:
            performSegue(withIdentifier: "Contact", sender: self)
        }
    }
    
    func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: ["com.NelsonBrumaire.RighteousRevenue.removeAd"])
        request.delegate = self
        request.start()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch transaction.transactionState {
            case .purchasing:
                //if item has been purchased
                print("Transaction in progress")
                break
            case .purchased, .restored:
                //payment failed
                print("Transaction Sucess")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed, .deferred:
                //payment was restored
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            @unknown default:
                //unkown Error New update or case
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
         
        }
        
       }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            if let product = response.products.first{
                myProduct = product
                print(product.price)
                print(product.productIdentifier)
            }
       }
       
}

