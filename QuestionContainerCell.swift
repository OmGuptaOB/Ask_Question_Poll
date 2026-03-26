//
//  QuestionContainerCell.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit
import SDWebImage

class QuestionContainerCell: UICollectionViewCell {
    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var optionOneView: SingleTextAndImageXib!
    @IBOutlet weak var optionTwoView: SingleTextAndImageXib!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        questionImageView.sd_cancelCurrentImageLoad()
        optionOneView.option_bg_image.sd_cancelCurrentImageLoad()
        optionTwoView.option_bg_image.sd_cancelCurrentImageLoad()
        questionImageView.image = nil
        optionOneView.option_bg_image.image = nil
        optionTwoView.option_bg_image.image = nil
        
        optionOneView.optiontextView.text = ""
        optionTwoView.optiontextView.text = ""
        questionDescription.text = ""
    }
    
    func configure(with question: QuestionModel, shouldHideClose: Bool = false) {
        
        questionDescription.text = question.description ?? ""
        
        //  Question image
        if let urlString = question.question_compress,
           let url = URL(string: urlString) {
            questionImageView.sd_imageTransition = .fade
            questionImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "img"))
        } else {
            questionImageView.image = UIImage(named: "img")
        }
        
        //  Hide labels
        optionOneView.OptionNumberTitle.isHidden    = true
        optionTwoView.OptionNumberTitle.isHidden    = true
        optionOneView.optionCharacterLimit.isHidden = true
        optionTwoView.optionCharacterLimit.isHidden = true
        
        let isTextMode = question.option_type == 1
        
        if isTextMode {
            //  Text options
            optionOneView.optiontextView.isHidden     = false
            optionTwoView.optiontextView.isHidden     = false
            optionOneView.optionImagePicker.isHidden  = true
            optionTwoView.optionImagePicker.isHidden  = true
            optionOneView.option_bg_image.image = UIImage(named: "option_button")
            optionTwoView.option_bg_image.image = UIImage(named: "option_button")
            
            optionOneView.optiontextView.text         = question.option1 ?? ""
            optionTwoView.optiontextView.text         = question.option2 ?? ""
            optionOneView.optiontextView.isEditable   = false
            optionTwoView.optiontextView.isEditable   = false
            
            optionOneView.centerTextViewContent(optionOneView.optiontextView)
            optionTwoView.centerTextViewContent(optionTwoView.optiontextView)
            
        } else {
            // Image options
            optionOneView.optiontextView.isHidden     = true
            optionTwoView.optiontextView.isHidden     = true
            optionOneView.optionImagePicker.isHidden  = true
            optionTwoView.optionImagePicker.isHidden  = true
            
            // Option 1 Image
            if let url1String = question.option1_compress_image,
               let url1 = URL(string: url1String) {
                
                optionOneView.option_bg_image.sd_setImage(
                    with: url1,
                    placeholderImage: UIImage(named: "img")
                )
            } else {
                optionOneView.option_bg_image.image = UIImage(named: "img")
            }
            
            // Option 2 Image
            if let url2String = question.option2_compress_image,
               let url2 = URL(string: url2String) {
                
                optionTwoView.option_bg_image.sd_setImage(
                    with: url2,
                    placeholderImage: UIImage(named: "img")
                )
            } else {
                optionTwoView.option_bg_image.image = UIImage(named: "img")
            }
        }
    }
}
