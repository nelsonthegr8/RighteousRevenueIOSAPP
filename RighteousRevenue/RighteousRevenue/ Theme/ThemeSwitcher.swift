//
//  ThemeSwitcher.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/18/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import SwiftTheme

private let lastThemeIndexKey = "lastedThemeIndex"
private let defaults = UserDefaults.standard

enum MyThemes: Int, CaseIterable {
    
    case light = 0
    case night = 1
    
    // MARK: -
    
    static var current: MyThemes { return MyThemes(rawValue: ThemeManager.currentThemeIndex)! }
    static var before = MyThemes.light
    
    // MARK: - Switch Theme
    
    static func switchTo(theme: MyThemes) {
        before = current
        ThemeManager.setTheme(index: theme.rawValue)
    }
    
    static func switchToNext() {
        var next = ThemeManager.currentThemeIndex + 1
        if next > 1 { next = 0 } // cycle and without Night
        switchTo(theme: MyThemes(rawValue: next)!)
    }
    
    // MARK: - Switch Night
    
    static func switchNight(isToNight: Bool) {
        switchTo(theme: isToNight ? .night : .light)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
    
    // MARK: - Save & Restore
    
    static func restoreLastTheme() {
        switchTo(theme: MyThemes(rawValue: defaults.integer(forKey: lastThemeIndexKey))!)
    }
    
    static func saveLastTheme() {
        defaults.set(ThemeManager.currentThemeIndex, forKey: lastThemeIndexKey)
    }
    
}
