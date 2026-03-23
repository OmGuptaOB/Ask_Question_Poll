//
//  LinkButtonXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit

class LinkButtonXib: NibView {

    @IBOutlet weak var lblLinkText: UILabel!
    
    @IBOutlet var btnForgotPassword: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitle()
    }
  
    func setupTitle() {
        let font = UIFont(name: "SFAtarianSystemExtended", size: 20)!
        let attributedString = NSAttributedString(
            string: lblLinkText.text ?? "",
            attributes: [
                .font: font,   // 🔥 THIS IS THE FIX
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        lblLinkText.attributedText = attributedString
        lblLinkText.layoutIfNeeded()
    }
    
}

//
//
//extension UILabel {
//    
//    func underlineText(alignment: ) {
//        guard let text = text else { return }
//        let attributedText = NSMutableAttributedString(string: text)
//        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.utf16.count))
//        self.attributedText = attributedText
//    }
//    
//}
