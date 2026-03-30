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
        btnLogOut.btnCustomLabel.setupButtonLabel(title: "logout",textColour: .black)
        btnLogOut.btnCustomClick.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
    }

    @objc func performLogout() {
            loader = showLoading(message: "")
            
            APIManager.shared.logout { [weak self] success, message in
                DispatchQueue.main.async {
                    self?.loader?.close()
                    if success {
                        // Clear token and user data
                        UserDefaultsManager.shared.clearLoginData()
                        self?.navigateToLogin()
                    } else {
                        // Even if API fails — clear local data and logout
                        UserDefaultsManager.shared.clearLoginData()
                        self?.navigateToLogin()
                    }
                }
            }
        }
    
    func navigateToLogin(){
        self.navigationController?.popToRootViewController(animated: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let loginVC = LoginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginVC)
        nav.navigationBar.isHidden = false
        appDelegate.window?.rootViewController = nav
        appDelegate.window?.makeKeyAndVisible()
        
    }
}
