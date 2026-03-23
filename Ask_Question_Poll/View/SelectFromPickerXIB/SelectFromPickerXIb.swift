//
//  SelectFromPickerXIb.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit

class SelectFromPickerXIb: NibView {

    @IBOutlet weak var selectDataTextField: UITextField!
    
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitle()
    }
    func setupTitle(){
        selectDataTextField.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        noteDescriptionLabel.font = UIFont(name: "SFAtarianSystemExtended", size: 10)
      }
}
