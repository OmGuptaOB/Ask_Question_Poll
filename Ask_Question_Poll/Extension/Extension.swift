//
//  ButtonSet.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit
//MARK: Label extension
extension UILabel {
    func setupButtonLabel(title: String = "CTA", textColour: UIColor = .white) {
        self.text = title
        self.textColor = textColour
    }
}
//MARK: Sting Validation
extension String {
    
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}

//MARK: Setup title in labels
extension UILabel {
    func setupTitle(size: CGFloat = 20, underline: Bool = false) {
        
        guard let fontName = UIFont(name: "SFAtarianSystemExtended", size: size) else {
            print(" Font 'SFAtarianSystemExtended' not found")
            self.font = UIFont.systemFont(ofSize: size)
            return
        }
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: fontName
        ]
        
        //  Only add underline if needed
        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.thick.rawValue
        }
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: attributes
        )
    }
}

//MARK: custom navbar
extension UINavigationController {
    func setupGlobalBackButton() {
        let backImage = UIImage(named: "back_img")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}

extension UIViewController {
    func setupDefaultNav() {
        navigationController?.setupGlobalBackButton()
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.titleView?.backgroundColor = .clear
    }
}

//MARK: hex colour
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

//MARK: font set
enum fontType {
    case BUTTON
    case DEFAULT
}

extension UIFont {
    
    convenience init(name: String, size: CGFloat, type: fontType) {
        switch type {
        case .BUTTON:
            if name.contains("SFAtarianBold") || name.contains("Atarian Bold") {
                self.init(name: "SFAtarianSystemExtended-Bold", size: size)!
            }else {
                self.init(name: "SFAtarianSystemExtended", size: size)!
            }
            break
        case .DEFAULT:
            if name.contains("SFAtarianBold") || name.contains("Atarian Bold") {
                self.init(name: "SFAtarianSystemExtended-Bold", size: size)!
            }else {
                self.init(name: "SFAtarianSystemExtended", size: size)!
            }
        }
    }
    
}
