//
//  ButtonXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit

class ButtonXib: NibView {

    @IBOutlet weak var btnCustomLabel: UILabel!
    
    @IBOutlet weak var btnCustomClick: UIButton!
    
    @IBOutlet var containerView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitle()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    func setupTitle() {
        let font = UIFont(name: "SFAtarianSystemExtended-Bold", size: 24)!

        let attributedString = NSAttributedString(
            string: btnCustomLabel.text ?? "",
            attributes: [
                .font: font,   // 🔥 THIS IS THE FIX
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        btnCustomLabel.attributedText = attributedString
//        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
    }
}
