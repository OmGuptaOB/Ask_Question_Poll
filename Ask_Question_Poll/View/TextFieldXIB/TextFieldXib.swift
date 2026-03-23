//
//  TextFieldXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit

class TextFieldXib: NibView {
    
    
@IBOutlet weak var textFieldTitle: UILabel!

@IBOutlet weak var textFieldTitleImage: UIImageView!

@IBOutlet weak var textFieldView: UIView!

@IBOutlet weak var textField: UITextField!

@IBOutlet weak var textFieldInsideImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitle()
        setupTextField()
    }
    
    func setupTitle(){
          textFieldTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 24)
      }
      
    func setupTextField() {
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.white.cgColor
        
        textField.borderStyle = .none
        
        //left padding for placeholder text
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always

    }
    
    
}
