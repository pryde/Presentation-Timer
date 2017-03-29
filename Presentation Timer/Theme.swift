//
//  Theme.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/18/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

struct ThemeColors {
    let Primary: UIColor
    let Secondary: UIColor
    
    let TextLight: UIColor
    let TextDark: UIColor
    let TextDefault: UIColor
    
    let BackgroundPrimary: UIColor
    let BackgroundSecondary: UIColor
}

enum FontStyle : String {
    case PrimaryLight, PrimaryRegular, PrimarySemibold, PrimaryBold
    case SecondaryLight, SecondaryRegular, SecondarySemibold, SecondaryBold
}

enum TextStyle : String {
    case Title, Subtitle
    case Body
}

protocol Theme {
    var colors: ThemeColors {get}
    
    func themeApplication()
    
    func font(style: FontStyle, size: CGFloat) -> UIFont
    func styleForTextStyle(textStyle: TextStyle) -> (font: UIFont, color: UIColor)
    
    func themeButton(button: UIButton)
    func themeLabel(label: UILabel, textStyle: TextStyle)
}

extension Theme {
    func themeLabel(label: UILabel, textStyle: TextStyle) {
        let style = styleForTextStyle(textStyle: textStyle)
        label.font = style.font
        label.textColor = style.color
    }
    
    func themeApplication() {
        UIApplication.shared.keyWindow?.tintColor = colors.Primary
    }
}

class ThemeManager {
    static var theme: Theme = DarkTheme()
}

class DarkTheme : Theme {
    let colors: ThemeColors
    
    init() {
        colors = ThemeColors(
            Primary: UIColor(colorLiteralRed: 20.0/255.0, green: 169.0/255.0, blue: 199.0/255.0, alpha: 1),
            Secondary: UIColor.blue,
            
            TextLight: UIColor(white: 0.9, alpha: 1),
            TextDark: UIColor(white: 0.6, alpha: 1),
            TextDefault: UIColor(white: 0.8, alpha: 1),
            
            BackgroundPrimary: UIColor(white: 0.2, alpha: 1),
            BackgroundSecondary: UIColor.lightGray
        )
    }
    
    func font(style: FontStyle, size: CGFloat) -> UIFont {
        var font: UIFont?
        
        switch style {
        case .PrimaryLight:
            font = UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
        case .PrimaryRegular:
            font = UIFont.systemFont(ofSize: size, weight: UIFontWeightRegular)
        case .PrimarySemibold:
            font = UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
        case .PrimaryBold:
            font = UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
        case .SecondaryLight:
            font = UIFont(name: "HelveticaNeue-Light", size: size)
        case .SecondaryRegular:
            font = UIFont(name: "HelveticaNeue", size: size)
        case .SecondarySemibold:
            font = UIFont(name: "HelveticaNeue-Medium", size: size)
        case .SecondaryBold:
            font = UIFont(name: "HelveticaNeue-Bold", size: size)
        }
        
        guard let finalFont = font else {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightRegular)
        }
        
        return finalFont
    }
    
    func styleForTextStyle(textStyle: TextStyle) -> (font: UIFont, color: UIColor) {
        var result: (font: UIFont, color: UIColor)
        switch textStyle {
        case .Title:
            result.font = font(style: .PrimarySemibold, size: 24)
            result.color = colors.TextLight
        case .Subtitle:
            result.font = font(style: .PrimaryRegular, size: 18)
            result.color = colors.TextDark
        case .Body:
            result.font = font(style: .PrimaryRegular, size: 14)
            result.color = colors.TextDefault
        }
        
        return result
    }
    
    func themeButton(button: UIButton) {
        button.setTitleColor(colors.Primary, for: .normal)
        button.titleLabel?.font = font(style: .PrimarySemibold, size: 18)
    }
}
