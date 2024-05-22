//
//  THEME.swift
//  BaseApp
//
//  Created by Mind on 14/02/24.
//  Copyright © 2024 Passio Inc. All rights reserved.
//

import UIKit

struct Custom {
    static let insetBackgroundRadius: CGFloat = 16.0
    static let buttonCornerRadius: CGFloat = 8.0
    static let engineeringViews = false
    static let useFirebase = false
    static let useNutritionBrowser = false
    static let oneLineAlternative = false
    static let oneSizeAlternative = true
}

// MARK: - UIColor
//extension UIColor { // customized colors
//
//    static var gray50: UIColor {
//        colorFromBundle(named: "gray-50") ?? .blue
//    }
//
//    static var gray200: UIColor {
//        colorFromBundle(named: "gray-200") ?? .blue
//    }
//
//    static var gray300: UIColor {
//        colorFromBundle(named: "gray-300") ?? .gray
//    }
//
//    static var gray400: UIColor {
//        colorFromBundle(named: "gray-400") ?? .blue
//    }
//
//    static var gray500: UIColor {
//        colorFromBundle(named: "gray-500-bg") ?? .blue
//    }
//
//    static var gray700: UIColor {
//        colorFromBundle(named: "gray-700") ?? .blue
//    }
//
//    static var gray900: UIColor {
//        colorFromBundle(named: "gray-900") ?? .blue
//    }
//
//    static var green100: UIColor {
//        colorFromBundle(named: "green-100") ?? .blue
//    }
//
//    static var green500: UIColor {
//        colorFromBundle(named: "green-500") ?? .blue
//    }
//
//    static var green800: UIColor {
//        colorFromBundle(named: "green-800") ?? .blue
//    }
//
//    static var indigo50: UIColor {
//        colorFromBundle(named: "indigo-50") ?? .blue
//    }
//
//    static var indigo100: UIColor {
//        colorFromBundle(named: "indigo-100") ?? .blue
//    }
//
//    static var indigo600: UIColor {
//        colorFromBundle(named: "indigo-600") ?? .blue
//    }
//
//    static var indigo700: UIColor {
//        colorFromBundle(named: "indigo-700") ?? .blue
//    }
//
//    static var lightBlue: UIColor {
//        colorFromBundle(named: "lightBlue") ?? .blue
//    }
//
//    static var purple500: UIColor {
//        colorFromBundle(named: "purple-500") ?? .blue
//    }
//
//    static var yellow500: UIColor {
//        colorFromBundle(named: "yellow-500") ?? .blue
//    }
//
//    static var red100: UIColor {
//        colorFromBundle(named: "red-100") ?? .blue
//    }
//
//    static var red500: UIColor {
//        colorFromBundle(named: "red-500") ?? .blue
//    }
//
//    static var red800: UIColor {
//        colorFromBundle(named: "red-800") ?? .blue
//    }
//}

// MARK: - UIFont
extension UIFont {

    enum Inter: String {
        case medium = "Inter-Medium"
        case light = "Inter-Light"
        case thin = "Inter-Thin"
        case bold = "Inter-Bold"
        case regular = "Inter-Regular"
        case extraBold = "Inter-ExtraBold"
        case extraLight = "Inter-ExtraLight"
        case black = "Inter-Black"
        case semiBold = "Inter-SemiBold"

        var name: String {
            self.rawValue
        }
    }

    class func custom(_ name: Inter, _ size : CGFloat = 15.0) -> UIFont {
        if let font = UIFont(name: name.name, size: size) {
            return font
        }
        print("Font Not Found -> \(name.rawValue)")
        return UIFont.systemFont(ofSize: size)
    }

    static func inter(type: Inter, size: CGFloat) -> UIFont {
        UIFont(name: type.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
