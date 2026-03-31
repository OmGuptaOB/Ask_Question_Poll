//
//  QuestionPreviewModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit

struct QuestionPreviewModel {
    var questionImage:  UIImage?
    var description:    String
    var isTextMode:     Bool
    
    // Text mode
    var option1Text:    String?
    var option2Text:    String?
    
    // Image mode
    var option1Image:   UIImage?
    var option2Image:   UIImage?
}
