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
import SwiftTheme
import UserNotifications
import SCLAlertView

class HomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var scriptureOfTheDay: UICollectionView!
    @IBOutlet weak var billsPie: PieChartView!
    @IBOutlet weak var addSection: GADBannerView!
    @IBOutlet weak var navSection: UINavigationBar!
    @IBOutlet weak var popOverBtn: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Variables
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
    private var selectedExpenseCheck = false
    private var monthlyIncomeAmnt = UserDefaults.standard.double(forKey: "UserMonthlyIncome")
    private var monthlyExpense = 0.0
    private var defaultTheme = UserDefaults.standard.bool(forKey: "CustomChoice")
    private var pieSelected = false
    private var scripturesOfTheDay:[ScripturesOfTheDay] = []
    var db: dataAccess?

//MARK: - Actions
    @IBAction func extraBtnPressed(){
        
        if(billsPie.highlighted.count == 0){ SCLAlertView().showError("No Selection", subTitle: "Please choose one of the pie sections that you would like to Add To or Customize.")
        }else{
            performSegue(withIdentifier: "showPopover", sender: nil)
        }
        
    }
    
}

//MARK: - View Controller Life Cycle
extension HomeViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.double(forKey: "UserMonthlyIncome") != monthlyIncomeAmnt){
            monthlyIncomeAmnt = UserDefaults.standard.double(forKey: "UserMonthlyIncome")
            updateUserPieTextWhenAmountIsChanged()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let tutorialViewController = storyboard.instantiateViewController(identifier: "TutorialViewController") as? TutorialViewController{
                tutorialViewController.modalPresentationStyle = .fullScreen
                present(tutorialViewController, animated: true, completion: nil)
            }
        }
        
        if(!CheckInternet.Connection()){
            UserDefaults.standard.set(true, forKey: "InternetDisconnected")
        }
        if(CheckInternet.Connection() && UserDefaults.standard.bool(forKey: "InternetDisconnected")){
            addGoogleAdsToView(addSection: addSection, view: self)
            UserDefaults.standard.set(false, forKey: "InternetDisconnected")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.bool(forKey: "FirstLaunch")){
            getUserDefaultThemeOnFirstLaunch()
        }
        db = dataAccess()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserPieTextWhenAmountIsChanged),
            name: NSNotification.Name(rawValue: ThemeUpdateNotification),
            object: nil
        )
        assignThemeColors()
        addGoogleAdsToView(addSection: addSection, view: self)
        setUpPieData()
        chartValueNothingSelected(billsPie)
        setupScriptureOfTheDayCollectionView()
        addSection.delegate = self
    }
    

//MARK: - Set Color Scheme
    func assignThemeColors() {
        billsPie.theme_backgroundColor = GlobalPicker.backgroundColor
        billsPie.holeColor = UIColor.clear
        addSection.theme_backgroundColor = GlobalPicker.backgroundColor
        addSection.theme_tintColor = GlobalPicker.textColor
        navSection.theme_barTintColor = GlobalPicker.cardColor
        navSection.theme_titleTextAttributes = GlobalPicker.navBarTitleText
        popOverBtn.theme_tintColor = GlobalPicker.tabButtonTintColor
        view.theme_backgroundColor = GlobalPicker.cardColor
        scriptureOfTheDay.theme_backgroundColor = GlobalPicker.backgroundColor
        UIApplication.shared.theme_setStatusBarStyle(GlobalPicker.StatusBarStyle, animated: true)
    }

}

//MARK: - Collection View Delegate & Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupScriptureOfTheDayCollectionView(){
//        let df = DateFormatter()
//        df.dateFormat = "dd/MM/yyyy"
//        let currentDate = df.string(from: Date())
//
//        let scriptureDate = UserDefaults.standard.string(forKey: "ScriptureOfTheDayDate")
//
//        if(UserDefaults.standard.structArrayData(ScripturesOfTheDay.self, forKey: "ScripturesOfTheDay").count > 0 && currentDate == scriptureDate){
//                scripturesOfTheDay = UserDefaults.standard.structArrayData(ScripturesOfTheDay.self, forKey: "ScripturesOfTheDay")
//            }else{
//            scripturesOfTheDay = loadDailyScriptureJson(filename: "Scriptures") ?? []
//            if(scripturesOfTheDay.count > 0){
//                var randomIndexes:[Int] = []
//                var scripturesPicked = false
//
//                while !scripturesPicked{
//                    let randomNum = Int.random(in: 0..<scripturesOfTheDay.count)
//
//                    if(randomIndexes.count < 3){
//                        if(!randomIndexes.contains(randomNum)){
//                            randomIndexes.append(randomNum)
//                        }
//                    }else{
//                        scripturesPicked = true
//                    }
//
//                }
//
//                var newChosenScriptures:[ScripturesOfTheDay] = []
//
//                for indexes in randomIndexes{
//                    newChosenScriptures.append(scripturesOfTheDay[indexes])
//                }
//
//                scripturesOfTheDay = newChosenScriptures
//
//                UserDefaults.standard.setStructArray(scripturesOfTheDay, forKey: "ScripturesOfTheDay")
//                UserDefaults.standard.set(currentDate, forKey: "ScriptureOfTheDayDate")
//            }
//        }
        scripturesOfTheDay = loadDailyScriptureJson(filename: "Scriptures") ?? []
        scriptureOfTheDay.delegate = self
        scriptureOfTheDay.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scripturesOfTheDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScriptureCollectionViewCell", for: indexPath) as! ScriptureOfTheDayCollectionViewCell
        cell.scriptureImg.image = UIImage(named: scripturesOfTheDay[indexPath.row].scriptureimg)
        cell.scriptureImg.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var url : URL?
        url = URL(string: scripturesOfTheDay[indexPath.row].biblelink)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

//MARK: - CollectionView Flow Delegate

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.3, height: collectionView.frame.height - 6)
    }
}

//MARK: - Pie Chart Styling And Information
extension HomeViewController{
    
    func setUpPieData()
    {
        sectionNames = db!.getSectionNames()
        
        for sectionID in sectionNames.indices{
            pieSections.append(db!.getPieData(Section: sectionID + 1))
        }
        
        for section in pieSections{
            let labelDisplay = sectionNames[section.section - 1]
            let sectionIcon = db!.getIconForSection(Section: section.section)
            let dataEntry = PieChartDataEntry(value: 16.6, label: labelDisplay, icon: UIImage(named: sectionIcon.iconName)!)
            if(section.symbol == "-"){
                monthlyExpense = monthlyExpense + section.sectionAmount
            }
            sectionStyle.append(sectionIcon)
            pieDataEntries.append(dataEntry)
        }
        
        billsPie.delegate = self
        updateChartData()
    }
    
    private func customPieTextStyling(){
          billsPie.legend.enabled = false
          billsPie.drawEntryLabelsEnabled = false
      }
      
    func clearPieChart(){
      billsPie.clear()
      sectionStyle = []
      pieSections = []
      pieDataEntries = []
      monthlyExpense = 0.0
      setUpPieData()
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
    
}

//MARK: - Pie Chart Delegate
extension HomeViewController: ChartViewDelegate{
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        let textColor = UIColor(named: GlobalPicker.aTextColor[ThemeManager.currentThemeIndex])
        let header = "Revenue:\n"
        let monthlyIncome = "+" + String(format: "$%.02f",monthlyIncomeAmnt)
        let middleheader = "\n\n Expenses:\n"
        let monthlyexpense = "-" + String(format: "$%.02f", monthlyExpense)
        let leftoverrev = UserDefaults.standard.double(forKey: "UserMonthlyIncome") - monthlyExpense
        let leftoverRevenue = String(format: "$%.02f", leftoverrev)
        //establish font
        let font = UIFont(name: "AppleSDGothicNeo-Light", size: 13)!
        let moneyFont = UIFont(name: "AppleSDGothicNeo-Light", size: 15)!
        //combine all sections together to form one
        let monthlyIncomeString: NSString = header + monthlyIncome as NSString
        let monthlyExpenseString: NSString = middleheader + monthlyexpense as NSString
        let monthlyLeftoverRevenue: NSString =  "\n\n Saved Income:\n" + leftoverRevenue as NSString
        // single out section that you would like styling on
        let MonthlyIncomeRange = (monthlyIncomeString).range(of: monthlyIncome)
        let MonthlyExpenseRange = (monthlyExpenseString).range(of: monthlyexpense)
        let monthlyLeftoverRevenueRange = (monthlyLeftoverRevenue).range(of: leftoverRevenue)
        //add style color to selected range and add to pie
        let allMonthlyIncomeRange = (monthlyIncomeString).range(of: monthlyIncomeString as String)
        let allMonthlyExpenseRange = (monthlyExpenseString).range(of: monthlyExpenseString as String)
        let allLeftoverExpenseRange = (monthlyLeftoverRevenue).range(of: monthlyLeftoverRevenue as String)
        //
        let monthlyIncomeAttribute = NSMutableAttributedString.init(string: monthlyIncomeString as String)
        let monthlyExpenseAttribute = NSMutableAttributedString.init(string: monthlyExpenseString as String)
        let monthlyLeftOverRevenueAttribute = NSMutableAttributedString.init(string: monthlyLeftoverRevenue as String)
        //create center text style
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        //add attributes to Monthly income text section
        monthlyIncomeAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor! , range: allMonthlyIncomeRange)
        monthlyIncomeAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "IncomeColor")! , range: MonthlyIncomeRange)
        monthlyIncomeAttribute.addAttribute(NSAttributedString.Key.font, value: font , range: allMonthlyIncomeRange)
        monthlyIncomeAttribute.addAttribute(NSAttributedString.Key.font, value: moneyFont , range: MonthlyIncomeRange)
        monthlyIncomeAttribute.addAttribute(.paragraphStyle, value: style, range: allMonthlyIncomeRange)
        //add attributes to Income Expense text
        monthlyExpenseAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor! , range: allMonthlyExpenseRange)
        monthlyExpenseAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "ExpenseColor")! , range: MonthlyExpenseRange)
        monthlyExpenseAttribute.addAttribute(NSAttributedString.Key.font, value: font , range: allMonthlyExpenseRange)
        monthlyExpenseAttribute.addAttribute(NSAttributedString.Key.font, value: moneyFont , range: MonthlyExpenseRange)
        monthlyExpenseAttribute.addAttribute(.paragraphStyle, value: style, range: allMonthlyExpenseRange)
        //add attributes to leftover expense
        monthlyLeftOverRevenueAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor! , range: allLeftoverExpenseRange)
        if(leftoverrev < 0){
            monthlyLeftOverRevenueAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "ExpenseColor")! , range: monthlyLeftoverRevenueRange)
        }else{
                monthlyLeftOverRevenueAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "IncomeColor")! , range: monthlyLeftoverRevenueRange)
            }
        monthlyLeftOverRevenueAttribute.addAttribute(NSAttributedString.Key.font, value: font , range: allLeftoverExpenseRange)
        monthlyLeftOverRevenueAttribute.addAttribute(NSAttributedString.Key.font, value: moneyFont , range: monthlyLeftoverRevenueRange)
        monthlyLeftOverRevenueAttribute.addAttribute(.paragraphStyle, value: style, range: allLeftoverExpenseRange)
        //concatenate the to texts together and display
        //I have done this so that the compiler does not mistake the two dollar amounts as the same range and give one section the colors
        monthlyIncomeAttribute.append(monthlyExpenseAttribute)
        monthlyIncomeAttribute.append(monthlyLeftOverRevenueAttribute)
        billsPie.centerAttributedText = monthlyIncomeAttribute
        
        //popOverBtn.isEnabled = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let textColor = UIColor(named: GlobalPicker.aTextColor[ThemeManager.currentThemeIndex])
        if( pieSections[Int(highlight.x)].symbol == "-"){
            selectedExpenseCheck = true
        }else{selectedExpenseCheck = false}
        //split string into sections for styling purposes
        let header = sectionNames[Int(highlight.x)] + "\n\n" + "Monthly Total:\n"
        let piesectionamount = pieSections[Int(highlight.x)].symbol + String(format: "$%.02f",pieSections[Int(highlight.x)].sectionAmount)
        let middleheader = "\n\n Total Entries:\n"
        let piesectionentries = String(pieSections[Int(highlight.x)].sectionBillAmount)
        //establish font
        let font = UIFont(name: "AppleSDGothicNeo-Light", size: 13)!
        let moneyFont = UIFont(name: "AppleSDGothicNeo-Light", size: 15)!
        //combine all sections together to form one
        let strNumber: NSString = header + piesectionamount + middleheader + piesectionentries as NSString
        // single out section that you would like styling on
        let sectionAmountRange = (strNumber).range(of: piesectionamount)
        //add style color to selected range and add to pie
        let allRange = (strNumber).range(of: strNumber as String)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        //create center text style
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        //add attributes to text
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor! , range: allRange)
        
        if(pieSections[Int(highlight.x)].symbol == "-"){
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "ExpenseColor")! , range: sectionAmountRange)
        }else{
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "IncomeColor")! , range: sectionAmountRange)
        }
        
        attribute.addAttribute(NSAttributedString.Key.font, value: font , range: allRange)
        attribute.addAttribute(NSAttributedString.Key.font, value: moneyFont , range: sectionAmountRange)
        attribute.addAttribute(.paragraphStyle, value: style, range: allRange)
        //finish other implementations for selected section number and name to pass to popover
        billsPie.centerAttributedText = attribute
        //popOverBtn.isEnabled = true
        selectedSectionNumber = Int(highlight.x)
        selectedSectionName = sectionNames[Int(highlight.x)]
    }
    
    
}

//MARK: - Segue Destination And Popover Delegate
extension HomeViewController: UIPopoverPresentationControllerDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPopover")
        {
            let popoverViewController = segue.destination as! HomePopoverViewController
            
            popoverViewController.sectionName = selectedSectionName
            popoverViewController.sectionNumber = selectedSectionNumber + 1
            
            popoverViewController.popoverPresentationController?.delegate = self
            
            popoverViewController.expenseCheck = selectedExpenseCheck
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func returnFromPopUpSegue(segue:UIStoryboardSegue){
        updateUserPieTextWhenAmountIsChanged()
    }
    
}

//MARK: - Google Ads Delegate
extension HomeViewController: GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

//MARK: - Check For If User Changes The Theme By Default
extension HomeViewController {

    func getUserDefaultThemeOnFirstLaunch(){
            switch traitCollection.userInterfaceStyle {
                case .light:
                MyThemes.switchNight(isToNight: false)
                case .dark:
                MyThemes.switchNight(isToNight: true)
                case .unspecified:
                break
                @unknown default:
                break
            }
    }

    @objc func updateUserPieTextWhenAmountIsChanged(){
    //this changes the text color of the inner circle for if it is selected and when it is not when the theme is changed
        if(billsPie.valuesToHighlight()){
        let highlighted = billsPie.highlighted[0]
        clearPieChart()
        billsPie.highlightValue(highlighted, callDelegate: true)
        }else{
        clearPieChart()
        }
    }

}
