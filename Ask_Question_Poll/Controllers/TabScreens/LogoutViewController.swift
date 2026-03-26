//
//  LogoutViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit
import SCLAlertView

class LogoutViewController: UIViewController {

    @IBOutlet weak var btnLogOut: ButtonXib!
    
    var loader: SCLAlertViewResponder?
    override func viewDidLoad() {
        super.viewDidLoad()
        stupButton()
    }
    func stupButton(){
        btnLogOut.btnCustomLabel.setupButton(title: "logout",textColour: .black)
        btnLogOut.btnCustomClick.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    @objc func logout(){
        let alert = SCLAlertView()
                alert.addButton("Yes, Logout") { [weak self] in
                    self?.performLogout()
                }
                alert.showWarning("Logout", subTitle: "Are you sure you want to logout?")
    }
    func performLogout() {
            loader = showLoading(message: "Logging out...")
            
            APIManager.shared.logout { [weak self] success, message in
                DispatchQueue.main.async {
                    self?.loader?.close()
                    
                    if success {
                        // ✅ Clear token and user data
                        UserDefaultsManager.shared.clearLoginData()
                        self?.navigateToLogin()
                    } else {
                        // ✅ Even if API fails — clear local data and logout
                        UserDefaultsManager.shared.clearLoginData()
                        self?.navigateToLogin()
                    }
                }
            }
        }
    
    func navigateToLogin(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
