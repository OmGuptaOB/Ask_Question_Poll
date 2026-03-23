//
//  SingleTextAndImageXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit

class SingleTextAndImageXib: NibView {

    @IBOutlet weak var OptionNumberTitle: UILabel!
    
    @IBOutlet weak var optionCharacterLimit: UILabel!
    
    
    func setupLabel(){
        OptionNumberTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        optionCharacterLimit.font = UIFont(name: "SFAtarianSystemExtended", size: 10)
        OptionNumberTitle.textColor = .white
        optionCharacterLimit.textColor = .white
      }

}
