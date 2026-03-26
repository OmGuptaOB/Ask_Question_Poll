//
//  RadioXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import UIKit

class RadioXib: NibView {

    @IBOutlet weak var radioFillimage: UIImageView!
    
    @IBOutlet weak var radioTitle: UILabel!
    
    @IBOutlet weak var radioClickToCheckUnCheck: UIButton!
    
    //  Current state
        private(set) var isSelected: Bool = false
        
        //  Parent gets notified when this radio is tapped
        var onSelected: (() -> Void)?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            updateUI()
            radioClickToCheckUnCheck.addTarget(self, action: #selector(radioTapped), for: .touchUpInside)
        }
        
        @objc private func radioTapped() {
            //  Notify parent to handle group deselection
            onSelected?()
        }
        
        //  Called externally to set state
        func setSelected(_ selected: Bool) {
            isSelected = selected
            updateUI()
        }
        
        private func updateUI() {
            //  Show filled circle when selected, empty when not
            radioFillimage.image = isSelected
                ? UIImage(systemName: "circle.inset.filled")
                : UIImage(systemName: "circle")
        }
    }
