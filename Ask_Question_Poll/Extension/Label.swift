//
//  Label.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit
extension UILabel {
    func setupTitle(size: CGFloat = 20, underline: Bool = false) {
        
        guard let fontName = UIFont(name: "SFAtarianSystemExtended", size: size) else {
            //allback if font not found — won't crash
            print(" Font 'SFAtarianSystemExtended' not found")
            self.font = UIFont.systemFont(ofSize: size)
            return
        }
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: fontName
        ]
        
        //  Only add underline if needed
        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: attributes
        )
    }
}
