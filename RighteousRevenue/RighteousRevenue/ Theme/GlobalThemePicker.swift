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
    static let backgroundColor: ThemeColorPicker = ["#BB5D5E", "#4D4E5D"]
    static let textColor: ThemeColorPicker = ["#000", "#FFFFFF"]
    //This is for the attributed text in the pie chart
    static let aTextColor: [String] = ["DarkBuyButtonColor","DarkTextColor"]
    static let navBarTitleText:ThemeStringAttributesPicker = [[NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBuyButtonColor")!],[NSAttributedString.Key.foregroundColor: UIColor(named: "DarkTextColor")!]]
    static let barBackgroundColor: ThemeColorPicker = ["#EB4F38", "#41424F"]
    static let tabButtonTintColor: ThemeColorPicker = ["#EB4F38", "#B1B1B8"]
    static let buttonTintColor: ThemeColorPicker = ["#EB4F38", "#FFFFFF"]
    static let buyButtonColor: ThemeColorPicker = ["#EB4F38", "#E0C185"]
    static let cardColor: ThemeColorPicker = ["#EB4F38", "#41424F"]
    static let userInterfaceStyle: [UIUserInterfaceStyle] = [.light,.dark]
    static let textBoxBorderColor: [UIColor] = [UIColor(named: "DarkCardColor")!,UIColor(named: "DarkButtonColor")!]
    static let ShadowColors = [UIColor.gray.cgColor,UIColor(named: "DarkCardColor")?.cgColor]
    
}
