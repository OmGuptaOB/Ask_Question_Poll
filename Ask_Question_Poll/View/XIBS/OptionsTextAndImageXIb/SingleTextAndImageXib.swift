//
//  SingleTextAndImageXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit
import SCLAlertView

class SingleTextAndImageXib: NibView {
    @IBOutlet weak var OptionNumberTitle: UILabel!
    @IBOutlet weak var optionCharacterLimit: UILabel!
    @IBOutlet weak var optiontextView: UITextView!
    @IBOutlet weak var option_bg_image: UIImageView!
    @IBOutlet weak var optionImagePicker: ImagePickerXib!
    
    var onImageTapped: (() -> Void)?
    var optionIndex: Int = 1
    var isImageSelected: Bool {
        return optionImagePicker.isImageSelected
    }
    var selectedImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // One-time setup when outlets are connected. Do not repeat in layoutSubviews —
        // that runs often and would stack duplicate gesture recognizers on the image view.
        setupLabel()
        setupImageTap()
        setupOptionImagePicker()
    }
    
    func setupOptionImagePicker() {
        optionImagePicker.isHidden = true // hidden by default
        optionImagePicker.onImageSelected = { [weak self] image in
            guard let self = self else { return }
            // Set selected image as background
            self.selectedImage = image
            self.option_bg_image.image = image
            print("Option \(self.optionIndex) image selected")
        }
    }
    
    func setupLabel(){
        OptionNumberTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        optionCharacterLimit.font = UIFont(name: "SFAtarianSystemExtended", size: 15)
        OptionNumberTitle.textColor = .white
        optionCharacterLimit.textColor = .white
        optiontextView.delegate = self
        
        // Center the text and cursor
        optiontextView.textAlignment = .center
        optiontextView.backgroundColor = .clear
        optiontextView.textColor = .white
        
        // Push content to vertical center
        optiontextView.contentInsetAdjustmentBehavior = .never
    }
    func setupImageTap() {
        option_bg_image.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        option_bg_image.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped() {
        onImageTapped?()  // tell HomeVC to open picker
    }
    func setupForTextMode() {
        optiontextView.isHidden = false
        optionImagePicker.isHidden = true
        optionImagePicker.cameraIconImageView.isHidden = true
        option_bg_image.image = UIImage(named: "option_button")
        let isEmpty = optiontextView.text.trimmingCharacters(in: .whitespaces).isEmpty
        OptionNumberTitle.isHidden = !isEmpty
        optionCharacterLimit.isHidden = !isEmpty
    }
    
    func setupForImageMode() {
        optiontextView.isHidden = true
        optionCharacterLimit.isHidden = true
        OptionNumberTitle.isHidden = true
        optionImagePicker.isHidden = false
        optionImagePicker.cameraIconImageView.isHidden = true

        if let saved = selectedImage {
              option_bg_image.image = saved
              optionImagePicker.imagePickerImage.image = saved
          } else {
              // No image selected yet — show placeholder
              let imageName = optionIndex == 1 ? "image_1" : "image_2"
              optionImagePicker.imagePickerImage.image = UIImage(named: imageName)
          }
    }
    
    func centerTextViewContent(_ textView: UITextView) {
        let totalHeight = textView.bounds.height
        let contentHeight = textView.contentSize.height
        let topInset = max(0, (totalHeight - contentHeight) / 2)
        textView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
}

extension SingleTextAndImageXib: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if text.isEmpty { return true }
        if updatedText.count > 30 {
            SCLAlertView().showError("Limit Reached", subTitle: "You can only enter 30 characters")
            textView.resignFirstResponder()
            return updatedText.count <= 30
        }
        return updatedText.count <= 30
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        OptionNumberTitle.isHidden = true
        optionCharacterLimit.isHidden = true
        centerTextViewContent(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        centerTextViewContent(textView)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            OptionNumberTitle.isHidden = false
            optionCharacterLimit.isHidden = false
        }
    }
    
}
