//
//  GlobalThemePicker.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/18/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import SwiftTheme

public let incomeColor = UIColor(named: "IncomeColor")!
public let expenseColor = UIColor(named: "ExpenseColor")!
public let themeNames = ["light","dark"]

enum GlobalPicker {
    static let backgroundColor: ThemeColorPicker = ["#F7F8F9", "#4D4E5D"]
    static let textColor: ThemeColorPicker = ["#202020", "#FFFFFF"]
    //This is for the attributed text in the pie chart
    static let aTextColor: [String] = ["LightTextColor","DarkTextColor"]
    static let navBarTitleText:ThemeStringAttributesPicker = [[NSAttributedString.Key.foregroundColor: UIColor(named: "LightTextColor")!],[NSAttributedString.Key.foregroundColor: UIColor(named: "DarkTextColor")!]]
    static let barBackgroundColor: ThemeColorPicker = ["#FEFEFE", "#41424F"]
    static let tabButtonTintColor: ThemeColorPicker = ["#80C34B", "#B1B1B8"]
    static let buttonTintColor: ThemeColorPicker = ["#202020", "#FFFFFF"]
    static let buyButtonColor: ThemeColorPicker = ["#4293F7", "#E0C185"]
    static let cardColor: ThemeColorPicker = ["#FEFEFE", "#41424F"]
    static let userInterfaceStyle: [UIUserInterfaceStyle] = [.light,.dark]
    static let textBoxBorderColor: [UIColor] = [UIColor(named: "LightBorderBoxColor")!,UIColor(named: "DarkButtonColor")!]
    static let colorSchemeImageBorderColor: [UIColor] = [UIColor(named: "LightUIColor")!,UIColor(named: "DarkUIColor")!]
    static let colorSchemeDropDownColor: [UIColor] = [UIColor(named: "LightCardColor")!,UIColor(named: "DarkCardColor")!]
    static let ShadowColors = [UIColor.gray.cgColor,UIColor(named: "DarkCardColor")?.cgColor]
    static let StatusBarStyle:ThemeStatusBarStylePicker = [.darkContent,.lightContent]
    static let buttonColor: [UIColor] = [UIColor(named: "LightTabButtonColor")!, UIColor(named: "DarkTabButtonColor")!]
    
}
