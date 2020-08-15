//
//  ViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import Charts
import GoogleMobileAds


class HomeViewController: UIViewController, ChartViewDelegate, UIPopoverPresentationControllerDelegate, GADBannerViewDelegate{
    let db = dataAccess()
    
    //MARK: - Outlets
    
    @IBOutlet weak var scriptureOfTheDay: UIImageView!
    @IBOutlet weak var billsPie: PieChartView!
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var navSection: UINavigationBar!
    @IBOutlet weak var popOverBtn: UIBarButtonItem!
    
    private enum piection: Int, CaseIterable{
        case Debt = 1
        case Bills = 2
        case Recreation = 3
        case Saving = 4
        case Giving = 5
        case Investments = 6
    }
    
    private var sectionNames:[String] = []
    
    private var pieSections: [ChartSectionInfo] = []
    private var pieDataEntries = [PieChartDataEntry]()
    private var sectionStyle = [IconChoice]()
    private var selectedSectionName = "test"
    private var selectedSectionNumber = 1
    private var monthlyExpense =  0.0
    
    //MARK: - View Controller Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let tutorialViewController = storyboard.instantiateViewController(identifier: "TutorialViewController") as? TutorialViewController{
                tutorialViewController.modalPresentationStyle = .fullScreen
                present(tutorialViewController, animated: true, completion: nil)
            }
        }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        addGoogleAdsToView(addSection: addSection, view: self)
        setUpPieData()
        chartValueNothingSelected(billsPie)
        addSection.delegate = self
    }
    
    func setUpPieData()
    {
        
        sectionNames = db.getSectionNames()
        
        for sectionID in sectionNames.indices{
            pieSections.append(db.getPieData(Section: sectionID + 1))
        }
        
        for section in pieSections{
            let labelDisplay = sectionNames[section.section - 1]
            let sectionIcon = db.getIconForSection(Section: section.section)
            let dataEntry = PieChartDataEntry(value: 16.6, label: labelDisplay, icon: UIImage(named: sectionIcon.iconName)!)
            monthlyExpense = monthlyExpense + section.sectionAmount
            sectionStyle.append(sectionIcon)
            pieDataEntries.append(dataEntry)
        }
        
        billsPie.delegate = self
        updateChartData()
    }
    
    func updateChartData()
    {
        let chartDataSet = PieChartDataSet(entries: pieDataEntries, label: nil)
        var colors = [UIColor]()
        chartDataSet.drawValuesEnabled = false
        
        for style in sectionStyle{
            let sectionColor = UIColor(named: style.sectionColor)!
            colors.append(sectionColor)
        }
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = colors
        
        billsPie.data = chartData
        
        customPieTextStyling()
        chartValueNothingSelected(billsPie)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        billsPie.centerText = "Monthly Revenue:\n" + String(format: "$%.02f",UserDefaults.standard.double(forKey: "UserMonthlyIncome")) + "\n\n Monthly Expenses:\n" + String(format: "$%.02f", monthlyExpense)
        popOverBtn.isEnabled = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let header = sectionNames[Int(highlight.x)] + "\n"
        billsPie.centerText = header + "Monthly Total:\n" + String(format: "$%.02f",pieSections[Int(highlight.x)].sectionAmount) + "\n Total Entries in Section:\n" + String(pieSections[Int(highlight.x)].sectionBillAmount)
        popOverBtn.isEnabled = true
        selectedSectionNumber = Int(highlight.x)
        selectedSectionName = sectionNames[Int(highlight.x)]
    }
    
    private func customPieTextStyling(){
        billsPie.legend.enabled = false
        billsPie.drawEntryLabelsEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPopover")
        {
            let popoverViewController = segue.destination as! HomePopoverViewController
            
            popoverViewController.sectionName = selectedSectionName
            popoverViewController.sectionNumber = selectedSectionNumber + 1
            
            popoverViewController.popoverPresentationController?.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func returnFromPopUpSegue(segue:UIStoryboardSegue){
        clearPieChart()
    }
    
    func clearPieChart(){
        billsPie.clear()
        sectionStyle = []
        pieSections = []
        pieDataEntries = []
        monthlyExpense = 0.0
        setUpPieData()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

