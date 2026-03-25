//
//  ShowQuestionViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit

class ShowQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var optionOneView: SingleTextAndImageXib!
    @IBOutlet weak var optionTwoView: SingleTextAndImageXib!
    @IBOutlet weak var btnClose: ButtonXib!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setOption()
        stupButton()
    }
    func setupLabel(){
        questionDescription.text = """
                            this is question label,
                        muliple line
                        muliple line
                        muliple line
                        muliple line     this is question label,
                        muliple line
                        muliple line
                        muliple line
                        muliple line     this is question label,
                        muliple line
                        muliple line
                        muliple line
                        muliple line
                        
                        """
    }
    
    func setOption(){
        optionOneView.OptionNumberTitle.isHidden = true
        optionTwoView.OptionNumberTitle.isHidden = true
        optionOneView.optionCharacterLimit.isHidden = true
        optionTwoView.optionCharacterLimit.isHidden = true
        optionOneView.optiontextView.text = "option one"
        optionTwoView.optiontextView.text = "option two"
    }
    
    func stupButton(){
        btnClose.btnCustomLabel.text = "close"
    }
}
