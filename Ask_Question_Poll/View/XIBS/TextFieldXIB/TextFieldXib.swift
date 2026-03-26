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
    
//@IBOutlet weak var titleImageAspectConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitle()
        setupTextField()
//        setAspect()
    }
    
    func setupTitle(){
          textFieldTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 26)
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
    
//    func setAspect() {
//        guard let image = textFieldTitleImage.image else { return }
//        
//        // Remove existing aspect constraint
//        titleImageAspectConstraint.isActive = false
//        
//        let aspectRatio = image.size.width / image.size.height
//        
//        // Create new constraint based on image's actual aspect ratio
//        titleImageAspectConstraint = textFieldTitleImage.widthAnchor.constraint(
//            equalTo: textFieldTitleImage.heightAnchor,
//            multiplier: aspectRatio
//        )
//        titleImageAspectConstraint.isActive = true
//        
//        layoutIfNeeded()
//    }
    
    
}
