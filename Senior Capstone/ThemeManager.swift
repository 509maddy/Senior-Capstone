import UIKit
import Foundation

/*
 Extend the UI color class to add a function for taking in hex values
 */
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

/*
 Enum for all of the hardcoded Theme settings
 */
enum Theme: Int {
    case coolBlue, warmOrange, darkTones
    
    /*
     Setting the based color for each of the color themes
     A beige tone for the lighter themes and a navy tone for the dark one
     */
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
    
    /*
     Setting one of the main colors for each of the color themes
     */
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
    
    /*
     Setting a second main color for each color theme
     */
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
    
    /*
     Setting the accent color for each theme
     The accent is the brightest color in the theme
     */
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
    
    /*
     Set the bar style so that it reflects the selected theme's tone
     */
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
    
    /*
     Set the main text color for each theme
     This color is used for titles and labels
     */
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
    
    /*
     Set the seconday text color for each theme
     This is a gray color slightly off from the main text color
     Used in the pie charts
     */
    var secondaryTextColor: UIColor {
        switch self {
        case .coolBlue:
            return UIColor().colorFromHexString("696969")
        case .warmOrange:
            return UIColor().colorFromHexString("696969")
        case .darkTones:
            return UIColor().colorFromHexString("DCDCDC")
        }
    }
}

let ThemeKey = "CurrentTheme"

class ThemeManager {
    
    /*
     Returns the curent theme selected by the user. If none currently selected, return coolBlue as a default
     */
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: ThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .coolBlue
        }
    }
    
    /*
     Returns a color for a slice in the pie chart.
     An equation is used for generated these colors based off the hardcoded values in the Theme
     This means that each slice in a pie char will have it's own unique color for that chart
     But each chart will have the same colors used in the same order
     */
    static func pieChartColor(sliceNumber: Int) -> UIColor {
        var cRed : CGFloat = 0
        var cGreen : CGFloat = 0
        var cBlue : CGFloat = 0
        var cAlpha: CGFloat = 0
        var color: UIColor
        
        // use one of the three main theme colors as a base
        switch sliceNumber%3 {
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
        
        // ajust the selected base color mathmatically such that it will create a consistent unique color.
        color = UIColor(
            red: ((cRed * 255) + CGFloat((sliceNumber * 31) % 30) - 15) / 255,
            green: ((cGreen * 255) + CGFloat((sliceNumber * 37) % 30) - 15) / 255,
            blue: ((cBlue * 255) + CGFloat((sliceNumber * 41) % 30) - 15) / 255,
            alpha: 1.0
        )
        
        return color
    }
    
    /*
     A bunch of settings that will impliment the color change when selected
     */
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: ThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.baseColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = theme.barStyle
        
        UISwitch.appearance().onTintColor = theme.baseColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.baseColor
        
    }
}
