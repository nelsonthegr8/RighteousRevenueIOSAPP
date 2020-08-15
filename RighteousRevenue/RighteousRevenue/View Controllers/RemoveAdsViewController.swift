//
//  RemoveAdsViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import StoreKit

class RemoveAdsViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var myProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchProducts()
    }

    @IBAction func buyBtnPressed(_ sender: Any) {
    
        guard let myProduct = myProduct else{return}
        
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
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
                UserDefaults.standard.set(true, forKey: "UserPayed")
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
