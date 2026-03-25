//
//  NavExtension.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import UIKit

extension UINavigationController {
    func setupGlobalBackButton() {
        let backImage = UIImage(named: "back_img")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}

extension UIViewController {
    func setupDefaultNav() {
        navigationController?.setupGlobalBackButton()
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.titleView?.backgroundColor = .clear
    }
}
