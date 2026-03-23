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
    
    @IBOutlet weak var optiontextView: UITextView!
    
    func setupLabel(){
        OptionNumberTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        optionCharacterLimit.font = UIFont(name: "SFAtarianSystemExtended", size: 10)
        OptionNumberTitle.textColor = .white
        optionCharacterLimit.textColor = .white
        optiontextView.delegate = self
      }


    
}
extension SingleTextAndImageXib: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        optionCharacterLimit.text = "\(textView.text.count)/\(200)"
//        textView.text.count = textView.text.count > 1 : OptionNumberTitle.isHidden = true,optionCharacterLimit.isHidden = true ?
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TextView started editing")
    }
}
