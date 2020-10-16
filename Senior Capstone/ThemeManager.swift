//
//  ThemeManager.swift
//  Senior Capstone
//
//  Created by Emily Howell on 10/14/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        let colorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        var rgbValue:UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

enum Theme: Int {
    case coolBlue, warmOrange, darkTones
    
    var baseColor: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("F2EEE5")
        case .warmOrange:
            return UIColor().colorFromHexString("E9E1D4")
        case .darkTones:
            return UIColor().colorFromHexString("051e3E")
        }
    }
    
    var mainColor1: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("C3E2DD")
        case .warmOrange:
            return UIColor().colorFromHexString("F5DDAD")
        case .darkTones:
            return UIColor().colorFromHexString("251E3E")
        }
    }
    
    var mainColor2: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("6ECEDA")
        case .warmOrange:
            return UIColor().colorFromHexString("F1BCAE")
        case .darkTones:
            return UIColor().colorFromHexString("451E3E")
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("E5C1C5")
        case .warmOrange:
            return UIColor().colorFromHexString("C9DECF")
        case .darkTones:
            return UIColor().colorFromHexString("851E3E")
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .coolBlue:
            return .default
        case .warmOrange:
            return .default
        case .darkTones:
            return .black
        }
    }
    
    var mainTextColor: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("000000")
        case .warmOrange:
            return UIColor().colorFromHexString("000000")
        case .darkTones:
            return UIColor().colorFromHexString("ffffff")
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("000000")
        case .warmOrange:
            return UIColor().colorFromHexString("000000")
        case .darkTones:
            return UIColor().colorFromHexString("ffffff")
        }
    }
}

let ThemeKey = "CurrentTheme"

class ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: ThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .coolBlue
        }
    }
    
    static func randomWheelColor() -> UIColor {
        var cRed : CGFloat = 0
        var cGreen : CGFloat = 0
        var cBlue : CGFloat = 0
        var cAlpha: CGFloat = 0
        var color: UIColor
        
        switch Int.random(in: 0...3) {
        case 0:
            color = currentTheme().mainColor1
        case 1:
            color = currentTheme().mainColor2
        case 2:
            color = currentTheme().accentColor
        default:
            color = currentTheme().baseColor
        }
        
        color.getRed(&cRed, green: &cGreen, blue: &cBlue, alpha: &cAlpha)
        color = UIColor(
            red: ((cRed * 255) + CGFloat(Float.random(in: -15...15))) / 255,
            green: ((cGreen * 255) + CGFloat(Float.random(in: -15...15))) / 255,
            blue: ((cBlue * 255) + CGFloat(Float.random(in: -15...15))) / 255,
            alpha: 1.0
        )
        
        return color
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: ThemeKey)
        UserDefaults.standard.synchronize()
        
        //tint?
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.baseColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = theme.barStyle
        
        UISwitch.appearance().onTintColor = theme.baseColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.baseColor
        
    }
}
