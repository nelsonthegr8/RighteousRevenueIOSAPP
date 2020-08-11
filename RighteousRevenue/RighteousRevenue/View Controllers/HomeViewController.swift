//
//  ViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ChartViewDelegate, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var scriptureOfTheDay: UIImageView!
    @IBOutlet weak var billsPie: PieChartView!
    @IBOutlet weak var addSection: UIView!
    @IBOutlet weak var navSection: UINavigationBar!
    @IBOutlet weak var popOverBtn: UIBarButtonItem!
    
    private enum pieSection: Int, CaseIterable{
        case Debt = 1
        case Bills = 2
        case Recreation = 3
        case Saving = 4
        case Giving = 5
        case Investments = 6
    }
    
    private var sectionNames:[String] = ["Debt","Bills","Recreation","Saving","Giving","Investments"]
    
    private var pieSections: [ChartSectionInfo] = []
    private var pieDataEntries = [PieChartDataEntry]()
    private var sectionStyle = [IconChoice]()
    private var selectedSectionName = "test"
    private var selectedSectionNumber = 1
    let db = dataAccess()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setUpPieData()
        chartValueNothingSelected(billsPie)
    }
    
    func setUpPieData()
    {
        for section in pieSection.allCases{
            pieSections.append(db.getPieData(Section: section.rawValue))
        }
        
        for section in pieSections{
            let labelDisplay = sectionNames[section.section - 1]
            let sectionIcon = db.getIconForSection(Section: section.section)
            let dataEntry = PieChartDataEntry(value: 16.6, label: labelDisplay, icon: UIImage(named: sectionIcon.iconName)!)
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
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        billsPie.centerText = "Monthly Revenue:\n" + "" + "\n Monthly Expenses:\n"
        popOverBtn.isEnabled = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let header = sectionNames[Int(highlight.x)] + "\n"
        billsPie.centerText = header + "Monthly Total:\n" + String(pieSections[Int(highlight.x)].sectionAmount) + "\n Total Entries in Section:\n" + String(pieSections[Int(highlight.x)].sectionBillAmount)
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
    
}

