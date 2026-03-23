//
//  HomeViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var selectCategoryPickerView: SelectFromPickerXIb!
    
    @IBOutlet weak var selectQuestionImageView: ImagePickerXib!
    
    @IBOutlet weak var writeDescriptionView: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var lblTextViewCharacterLimit: UILabel!
    
    
    @IBOutlet weak var radioTextOption: RadioXib!
    
    
    @IBOutlet weak var radioImageOption: RadioXib!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
}
