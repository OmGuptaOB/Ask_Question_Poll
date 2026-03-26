//
//  ViewAnalysisCell.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit

class ViewAnalysisCell: UITableViewCell {

    @IBOutlet weak var LabelQuestionDescription: UILabel!
    @IBOutlet weak var btnViewAnalysis: ButtonXib!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtn()
    }
    
    func setupBtn(){
        btnViewAnalysis.btnCustomLabel.setupButton(title: "view analysis", textColour: .black)
        btnViewAnalysis.btnCustomLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
}
