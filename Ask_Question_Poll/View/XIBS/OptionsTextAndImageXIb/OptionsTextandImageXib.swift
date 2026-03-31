//
//  OptionsTextandImageXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 24/03/26.
//

import UIKit

class OptionsTextandImageXib: NibView {
    @IBOutlet weak var optionOneView: SingleTextAndImageXib!
    @IBOutlet weak var optionTwoView: SingleTextAndImageXib!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Tell each view which option it is
        optionOneView.optionIndex = 1
        optionTwoView.optionIndex = 2
    }
}
