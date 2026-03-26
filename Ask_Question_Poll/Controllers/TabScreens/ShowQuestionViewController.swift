//
//  ShowQuestionViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit
import SDWebImage

class ShowQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var optionOneView: SingleTextAndImageXib!
    @IBOutlet weak var optionTwoView: SingleTextAndImageXib!
    @IBOutlet weak var btnClose: ButtonXib!
    
    var previewData: AddQuestionRequestModel?
    var questionData: QuestionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stupButton()
        populateFromPreview()
        navigationController?.isNavigationBarHidden = true
        questionImageView.backgroundColor = .clear
    }
    
    func populateFromPreview(){
        
        guard let data = previewData else { return }
        
        if let image = data.questionImage {
            questionImageView.image = image
            questionImageView.isHidden = false
        } else {
            questionImageView.isHidden = true
        }
        questionDescription.text = data.description
        
        optionOneView.OptionNumberTitle.isHidden = true
        optionTwoView.OptionNumberTitle.isHidden = true
        optionOneView.optionCharacterLimit.isHidden = true
        optionTwoView.optionCharacterLimit.isHidden = true
        
        let isTextMode = data.option_type == 1
        
        if isTextMode {
            // Show text views
            optionOneView.optiontextView.isHidden = false
            optionTwoView.optiontextView.isHidden = false
            optionOneView.optionImagePicker.isHidden = true
            optionTwoView.optionImagePicker.isHidden = true
            
            optionOneView.optiontextView.text = data.option1
            optionTwoView.optiontextView.text = data.option2
            
            optionOneView.optiontextView.isEditable = false
            optionTwoView.optiontextView.isEditable = false
            
            optionOneView.centerTextViewContent(optionOneView.optiontextView)
            optionTwoView.centerTextViewContent(optionTwoView.optiontextView)
            
        } else {
            // Show images on bg imageview
            optionOneView.optiontextView.isHidden    = true
            optionTwoView.optiontextView.isHidden    = true
            optionOneView.optionImagePicker.isHidden = true
            optionTwoView.optionImagePicker.isHidden = true
            
            if let img1 = data.optionOneImage {
                optionOneView.option_bg_image.image = img1
                
            }
            if let img2 = data.optionTwoImage {
                optionTwoView.option_bg_image.image = img2
            }
        }
    }
    
    
    func stupButton(){
        btnClose.btnCustomLabel.setupButton(title: "close",textColour: .black)
        btnClose.btnCustomClick.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    @objc func closeView(){
        self.navigationController?.popViewController(animated: true)
    }
}
