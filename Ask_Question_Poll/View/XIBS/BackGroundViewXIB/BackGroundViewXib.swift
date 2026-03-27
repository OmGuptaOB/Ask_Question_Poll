//
//  BackGroundViewXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit

class BackGroundViewXib: NibView {
    @IBOutlet var containerView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConatinerView()
    }

    func setupConatinerView() {
        containerView.layer.cornerRadius = 7
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 252/255, green: 207/255, blue: 28/255, alpha: 1).cgColor
    }
    
}
