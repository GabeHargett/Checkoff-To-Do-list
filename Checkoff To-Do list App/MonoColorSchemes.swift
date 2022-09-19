//
//  MonochromaticColorSchemes.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 6/1/22.
//

import UIKit

enum ColorScheme: Int {
    case black = 0
    case blue = 1
    case purple = 2
    case red = 3
    case silver = 4
    case pink = 5
    case brown = 6
    case green = 7
}
extension UIColor {
    
    static let background = UIColor.white
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {

        guard hex.first == "#" else {
            self.init()
            return
        }

        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((rgb & 0xFF)) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    
    
    static var mainColor1: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case.black:
            return UIColor.black
        case .blue:
            return UIColor(hex: "#1666ba")
        case .purple:
            return UIColor(hex: "#6f3f74")
        case .red:
            return UIColor(hex: "#d90809")
        case .silver:
            return UIColor(hex: "#4c4c4c")
        case .pink:
            return UIColor(hex: "#f45ca2")
        case .brown:
            return UIColor(hex: "#5f4f3e")
        case .green:
            return UIColor(hex: "#358873")

        }
    }
    static var mainColor2: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case .black:
            return UIColor.systemGray
        case .blue:
            return UIColor(hex: "#368ce7")
        case .purple:
            return UIColor(hex: "#965b96")
        case .red:
            return UIColor(hex: "#fc3e3f")
        case .silver:
            return UIColor(hex: "#666666")
        case .pink:
            return UIColor(hex: "#f27cb2")
        case .brown:
            return UIColor(hex: "#877058")
        case .green:
            return UIColor(hex: "#4E9C81")


        }
    }
    static var mainColor3: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case .black:
            return UIColor.systemGray3
        case .blue:
            return UIColor(hex: "#7ab3ef")
        case .purple:
            return UIColor(hex: "#bb85b7")
        case .red:
            return UIColor(hex: "#ff6666")
        case .silver:
            return UIColor(hex: "#7f7f7f")
        case .pink:
            return UIColor(hex: "#fba1ca")
        case .brown:
            return UIColor(hex: "#a58a6e")
        case .green:
            return UIColor(hex: "#6BAF92")


        }
    }
    static var mainColor4: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case .black:
            return UIColor.systemGray4
        case .blue:
            return UIColor(hex: "#bedaf7")
        case .purple:
            return UIColor(hex: "#cda4ca")
        case .red:
            return UIColor(hex: "#fb9b9b")
        case .silver:
            return UIColor(hex: "#999999")
        case .pink:
            return UIColor(hex: "#ffbedc")
        case .brown:
            return UIColor(hex: "#b9a58f")
        case .green:
            return UIColor(hex: "#8DC3A7")


        }
    }
    static var mainColor5: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case .black:
            return UIColor.systemGray5
        case .blue:
            return UIColor(hex: "#deecfb")
        case .purple:
            return UIColor(hex: "#e5c8de")
        case .red:
            return UIColor(hex: "#ffcccc")
        case .silver:
            return UIColor(hex: "#b3b1b2")
        case .pink:
            return UIColor(hex: "#ffe2f0")
        case .brown:
            return UIColor(hex: "#d0c2b3")
        case .green:
            return UIColor(hex: "#B4D6C1")

        }
        //edit
        
        
        
        
    }
    static var mainColor6: UIColor {
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.integer(forKey: "ColorScheme")) ?? .blue
        switch colorScheme {
        case .black:
            return UIColor.white
        case .blue:
            return UIColor(hex: "#deecfb")
        case .purple:
            return UIColor(hex: "#eddde8")
        case .red:
            return UIColor(hex: "#fce0df")
        case .silver:
            return UIColor(hex: "#cccccc")
        case .pink:
            return UIColor(hex: "#ffe2f0")
        case .brown:
            return UIColor(hex: "#e3dad1")
        case .green:
            return UIColor(hex: "#DFEAE2")


        }
    }
}
