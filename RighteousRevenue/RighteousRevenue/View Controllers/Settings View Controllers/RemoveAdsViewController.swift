//
//  RemoveAdsViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/15/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import NVActivityIndicatorView
import SwiftTheme

class RemoveAdsViewController: UIViewController{
//MARK: - Outlets
    @IBOutlet var buyBtn: UIButton!
    @IBOutlet var restorePurchaseBtn: UIButton!
    @IBOutlet var buyIcon: UIImageView!
    @IBOutlet var buyText: UILabel!
    @IBOutlet var loading: NVActivityIndicatorView!
    @IBOutlet var cardView: UIView!
    
//MARK: - Variables
    var myProduct: SKProduct?
    
//MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loading.isHidden = true
        setColorTheme()
        if(!userPayedCheck()){
            fetchProducts()
        }
    }
    
//MARK: - Actions
    @IBAction func buyBtnPressed(_ sender: Any) {
        
        loading.isHidden = false
        loading.startAnimating()
        
        guard let myProduct = myProduct else{return}
        
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    @IBAction func RestorePurchasePressed(_ sender: UIButton){
        loading.isHidden = false
        loading.startAnimating()
        restorePurchase()
    }
    

    
//MARK: - Set Color Scheme
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        buyBtn.theme_backgroundColor = GlobalPicker.buyButtonColor
        buyBtn.theme_tintColor = GlobalPicker.textColor
        buyBtn.layer.cornerRadius = 5
        buyIcon.theme_tintColor = GlobalPicker.tabButtonTintColor
        buyText.theme_textColor = GlobalPicker.textColor
        restorePurchaseBtn.theme_tintColor = GlobalPicker.tabButtonTintColor
        overrideUserInterfaceStyle = GlobalPicker.userInterfaceStyle[ThemeManager.currentThemeIndex]
        setCardView()
    }
    
    func setCardView(){
     cardView.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
        cardView.theme_backgroundColor = GlobalPicker.cardColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 10.0
    }
}

//MARK: - Products Delegate and Observer
extension RemoveAdsViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {

    func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: ["com.NelsonBrumaire.RighteousRevenueApp.removeAds"])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            if let product = response.products.first{
                myProduct = product
                print(product.price)
                print(product.productIdentifier)
            }
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
                    loading.isHidden = true
                    loading.stopAnimating()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                    UserDefaults.standard.set(true, forKey: "UserPayed")
                    _ = userPayedCheck()
                    alertSystem()
                    break
                case .failed, .deferred:
                    //payment was restored
                    print("Transaction Failed")
                    loading.isHidden = true
                    loading.stopAnimating()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                    break
                @unknown default:
                    //unkown Error New update or case
                    loading.isHidden = true
                    loading.stopAnimating()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                    break
            }

        }

    }
    
    func restorePurchase(){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.loading.isHidden = true
                self.loading.stopAnimating()
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                UserDefaults.standard.set(true, forKey: "UserPayed")
                _ = self.userPayedCheck()
                self.loading.isHidden = true
                self.loading.stopAnimating()
                self.alertSystem()
            }
            else {
                print("Nothing to Restore")
                self.loading.isHidden = true
                self.loading.stopAnimating()
            }
        }
    }
    
    func userPayedCheck() -> Bool{
        var check = false
        if(UserDefaults.standard.bool(forKey: "UserPayed")){
            buyIcon.image = UIImage(named: "UserPayedIcon")
            buyText.text = "You have Removed ads!\n Thank You!"
            buyBtn.isHidden = true
            restorePurchaseBtn.isHidden = true
            check = true
        }else{
            check = false
        }
        
        return check
    }
    
    func alertSystem(){
        let alert = UIAlertController(title: "Thank You!", message: "Thank you for your purchase! Please restart the app to have all ads removed.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
