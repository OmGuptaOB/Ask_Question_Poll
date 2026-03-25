//
//  UIViewController+Alert.swift
//  Ask_Question_Poll
//
//  Created by Antigravity on 25/03/26.
//

import UIKit
import SCLAlertView

extension UIViewController {
    
    func showError(_ message: String) {
        SCLAlertView().showError(message, subTitle: "")
    }
    
    func showSuccess(_ message: String, subTitle: String = "") {
        SCLAlertView().showSuccess(message, subTitle: subTitle)
    }
    
    func showLoading(title: String = "Please wait", message: String) -> SCLAlertViewResponder {
        return SCLAlertView().showWait(title, subTitle: message, colorStyle: 0xFFD110)
    }
}
