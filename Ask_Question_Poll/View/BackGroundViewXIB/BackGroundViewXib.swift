//
//  BackGroundViewXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit

class BackGroundViewXib: UIView {

    
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConatinerView()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BackGroundViewXib", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        // Ensure initial layout is clean
        layoutIfNeeded()
    }
    
    func setupConatinerView() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 252/255, green: 207/255, blue: 28/255, alpha: 1).cgColor
    }
    
}
