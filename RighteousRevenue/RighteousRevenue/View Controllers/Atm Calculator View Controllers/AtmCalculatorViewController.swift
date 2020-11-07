//
//  AtmCalculatorViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 10/29/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import iOSDropDown
import GoogleMobileAds
import SwiftTheme
import SCLAlertView

class AtmCalculatorViewController: UIViewController {
//MARK: Outlets
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var billDropDown: DropDown!
    @IBOutlet var billsCollectionView: UICollectionView!
    @IBOutlet var atmTotalLbl: UILabel!
    @IBOutlet var switch50: UISwitch!
    @IBOutlet var switch100: UISwitch!
    @IBOutlet var lbl100: UILabel!
    @IBOutlet var lbl50: UILabel!
    @IBOutlet var lbl20: UILabel!
    @IBOutlet var lbl10: UILabel!
    @IBOutlet var lbl5: UILabel!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl100txt: UILabel!
    @IBOutlet var lbl50txt: UILabel!
    @IBOutlet var lbl20txt: UILabel!
    @IBOutlet var lbl10txt: UILabel!
    @IBOutlet var lbl5txt: UILabel!
    @IBOutlet var lbl1txt: UILabel!
    @IBOutlet var switchlbl100: UILabel!
    @IBOutlet var switchlbl50: UILabel!
    @IBOutlet var calculationsView: UIView!
    @IBOutlet var cardView: UIView!
    @IBOutlet var navButton: UIBarButtonItem!
    
    
//MARK: Variables
    var db: dataAccess?
    var billsInfo:[MoreInfoForPieSection] = []
    let reuseIdentifier = "atmBillInfoCell"
    var breakdownAmnt:Double = 0.0
    var defaultAtmCalc = atmCalculationResult()
    var selectedAmounts:[Int] = []
    
//MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        db = dataAccess()
        styleView()
        loadDropDownData()
        addGoogleAdsToView(addSection: addSection, view: self)
        addSection.delegate = self
        setupAtmBillsInfoCollectionView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateThemeThatIsNotNative),
            name: NSNotification.Name(rawValue: ThemeUpdateNotification),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDropDownData()
        
        if(billDropDown.selectedIndex != nil)
        {
            grabAtmBillsInfo(id: billDropDown.optionIds![billDropDown.selectedIndex!])
            breakdownAmnt = 0
            atmTotalLbl.text = String(format: "$%.02f",breakdownAmnt)
            selectedAmounts.removeAll()
            calculateAtmInformation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(billDropDown.isSelected){
            billDropDown.hideList()
        }
    }

//MARK: Style View
    private func styleView()
    {
        billDropDown.checkMarkEnabled = false
        billDropDown.theme_backgroundColor = GlobalPicker.backgroundColor
        billDropDown.theme_placeholderAttributes = GlobalPicker.navBarTitleText
        billDropDown.theme_textColor = GlobalPicker.textColor
        billsCollectionView.theme_backgroundColor = GlobalPicker.cardColor
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        calculationsView.theme_backgroundColor = GlobalPicker.cardColor
        navigationController?.navigationBar.theme_barTintColor = GlobalPicker.cardColor
        navigationController?.navigationBar.theme_titleTextAttributes = GlobalPicker.navBarTitleText
        UIApplication.shared.theme_setStatusBarStyle(GlobalPicker.StatusBarStyle, animated: true)
        addSection.backgroundColor = UIColor.clear
        navButton.theme_tintColor = GlobalPicker.tabButtonTintColor
        styleSwitches()
        styleViewWithThemeIndex()
        roundViewCorners()
        setLblColors()
    }
    
    private func styleViewWithThemeIndex()
    {
        let themeindex = ThemeManager.currentThemeIndex
        billDropDown.rowBackgroundColor = GlobalPicker.colorSchemeDropDownColor[themeindex]
        billDropDown.arrowColor = GlobalPicker.buttonColor[themeindex]
        billDropDown.selectedRowColor = GlobalPicker.colorSchemeImageBorderColor[themeindex]
        cardView.layer.shadowColor = GlobalPicker.ShadowColors[themeindex]
        overrideUserInterfaceStyle = GlobalPicker.userInterfaceStyle[themeindex]
    }
    
    private func roundViewCorners()
    {
        let views: [UIView] = [cardView]
        
        for cardview in views
        {
            cardview.theme_backgroundColor = GlobalPicker.cardColor
            cardview.layer.shadowColor = GlobalPicker.ShadowColors[ThemeManager.currentThemeIndex]
            cardview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cardview.layer.shadowOpacity = 1.0
            cardview.layer.masksToBounds = false
            cardview.layer.cornerRadius = 10.0
        }
        
    }
    
    private func styleSwitches()
    {
        let switches:[UISwitch] = [switch50,switch100]
        
        for Switch in switches
        {
            Switch.theme_backgroundColor = GlobalPicker.cardColor
            Switch.theme_thumbTintColor = GlobalPicker.backgroundColor
            Switch.theme_onTintColor = GlobalPicker.tabButtonTintColor
        }
        
    }
    
    private func setLblColors()
    {
        let lbls: [UILabel] = [lbl1,lbl5,lbl10,lbl20,lbl50,lbl100,
                lbl1txt,lbl5txt,lbl10txt,lbl20txt,lbl50txt,lbl100txt,
                atmTotalLbl,switchlbl50,switchlbl100]
        for lbl in lbls
        {
            lbl.theme_textColor = GlobalPicker.textColor
        }
        
    }
    
//MARK: IBActions
    
    @IBAction func FiftySwitchTapped(_ sender: Any) {
        calculateAtmInformation()
    }
    
    @IBAction func HundredSwitchTapped(_ sender: Any) {
        calculateAtmInformation()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if(billDropDown.selectedIndex != nil)
        {
            performSegue(withIdentifier: "quickAddSection", sender: nil)
        }
        else
        {
            //show Alert
            SCLAlertView().showError("No Selection", subTitle: "Please choose one of the sections that you would like to Add To or Delete from in the dropdown menu.")
        }
    }
    
    @IBAction func returnFromAddAtmSegue(segue:UIStoryboardSegue){
        viewWillAppear(true)
    }
    
    @objc func updateThemeThatIsNotNative(){
        styleViewWithThemeIndex()
        
        if(billDropDown.isSelected)
        {
            billDropDown.hideList()
        }
            
    }

}

//MARK: Collection View Flow Layout
extension AtmCalculatorViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return billsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AtmBillInfoCollectionViewCell
        
        cell.billNamelbl.text = billsInfo[indexPath.row].billName
        cell.billPricelbl.text = String(format: "$%.02f",billsInfo[indexPath.row].billAmount)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AtmBillInfoCollectionViewCell
        let i = indexPath.row
        
        if(cell.rowChkbx.on)
        {
            cell.rowChkbx.setOn(false, animated: true)
            billsInfo[i].selected = false
            let j = selectedAmounts.firstIndex(of: Int(billsInfo[i].billAmount))
            selectedAmounts.remove(at: j!)
            calculateAtmInformation()
        }else{
            cell.rowChkbx.setOn(true, animated: true)
            billsInfo[i].selected = true
            selectedAmounts.append(Int(billsInfo[i].billAmount))
            calculateAtmInformation()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! AtmBillInfoCollectionViewCell
        cell.rowChkbx.on = billsInfo[indexPath.row].selected
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 5, height: collectionView.frame.height/2.5)
    }
    
    func setupAtmBillsInfoCollectionView()
    {
        billsCollectionView.delegate = self
        billsCollectionView.dataSource = self
    }
    
    func grabAtmBillsInfo(id: Int) {
        billsInfo = db?.grabMoreInfoForSection(Section: id) ?? []
        billsCollectionView.reloadData()
    }
    
}

//MARK: Functions and Actions
extension AtmCalculatorViewController{
    
    private func loadDropDownData()
    {
        billDropDown.optionArray = db?.getSectionNames() ?? []
        billDropDown.optionIds = db?.getSectionIds() ?? []
        
        billDropDown.didSelect { (selectedName, index, id) in
            self.grabAtmBillsInfo(id: id)
            self.breakdownAmnt = 0
            self.selectedAmounts.removeAll()
            self.calculateAtmInformation()
        }
    }
    
    private func calculateAtmInformation()
    {
        calcAtmInfoHelper()
        
        atmTotalLbl.text = String(format: "$%.02f",breakdownAmnt)
        lbl100.text = String(defaultAtmCalc.hundred)
        lbl50.text = String(defaultAtmCalc.fifty)
        lbl20.text = String(defaultAtmCalc.twenty)
        lbl10.text = String(defaultAtmCalc.ten)
        lbl5.text = String(defaultAtmCalc.five)
        lbl1.text = String(defaultAtmCalc.one)
        
    }
    
    private func calcAtmInfoHelper()
    {
        defaultAtmCalc = atmCalculationResult()
        breakdownAmnt = 0
        
        if(selectedAmounts.count > 0){
            for Amount in selectedAmounts{
                let info = atmCalculationResult(amount: Amount, hundredEnabled: switch100.isOn, fiftyEnabled: switch50.isOn)
                
                breakdownAmnt += Double(Amount)
                defaultAtmCalc.hundred += info.hundred
                defaultAtmCalc.fifty += info.fifty
                defaultAtmCalc.twenty += info.twenty
                defaultAtmCalc.ten += info.ten
                defaultAtmCalc.five += info.five
                defaultAtmCalc.one += info.one
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "quickAddSection")
        {
            let vc = segue.destination as! AddViewController
            vc.Section = billDropDown.optionIds![billDropDown.selectedIndex!]
            vc.SectionTitle = billDropDown.optionArray[billDropDown.selectedIndex!]
            vc.isAccessedFromCalculator = true
        }
    }
    
}

//MARK: Google Ads
extension AtmCalculatorViewController: GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

