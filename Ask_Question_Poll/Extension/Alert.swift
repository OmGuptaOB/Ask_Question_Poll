//
//  UIViewController+Alert.swift
//  Ask_Question_Poll
//
//  Created by Antigravity on 25/03/26.
//

import UIKit
import SCLAlertView

let appearance = SCLAlertView.SCLAppearance(
    showCloseButton: false
)

let alert = SCLAlertView(appearance: appearance)

func showError(_ message: String) {
    SCLAlertView().showError(message, subTitle: "")
}

func showSuccess(_ message: String, subTitle: String = "") {
    SCLAlertView().showSuccess(message, subTitle: subTitle)
}

func showLoading(title: String = "Please wait", message: String) -> SCLAlertViewResponder {
    return alert.showWait(title, subTitle: message, colorStyle: 0xFFD110)
}

func showNoDataAlert(on vc: UIViewController,title: String = "",message: String = "Please add question first") {
    
    let alert = SCLAlertView(appearance: appearance)
    
    alert.addButton("OK",textColor: UIColor.white) {
        if let tabVC = vc.parent as? TabBarViewController {
            tabVC.selectTab(at: 1)
        }
    }
    alert.showWarning(title, subTitle: message,closeButtonTitle: nil,colorStyle: 0x007BFF)
}
