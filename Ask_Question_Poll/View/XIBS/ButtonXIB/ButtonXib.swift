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
    
    func setupTitle() {
        let font = UIFont(name: "Atarian", size: 24,type: .DEFAULT)
        let attributedString = NSAttributedString(
            string: btnCustomLabel.text ?? "",
            attributes: [
                .font: font,
            ]
        )
        btnCustomLabel.attributedText = attributedString
        containerView.clipsToBounds = true
    }
}
