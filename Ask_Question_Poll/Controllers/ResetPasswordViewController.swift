//
//  ResetPasswordViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import UIKit
import SCLAlertView

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var enterNewPasswordView: TextFieldXib!
    
    @IBOutlet weak var enterConfirmNewPasswordView: TextFieldXib!
    
    @IBOutlet weak var btnSaveNewPassword: ButtonXib!
    
    
    var email:String?
    var resetToken: String?
    
    var loader: SCLAlertViewResponder?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTextFields()
        setupSaveButton()
    }
    func setupNav() {
        navigationController?.setupGlobalBackButton()
        self.navigationItem.backButtonTitle = ""
    }
    func setupTextFields() {
        enterNewPasswordView.textFieldTitle.text = "new password"
        enterNewPasswordView.textFieldTitleImage.isHidden = true
        enterNewPasswordView.textField.placeholder  = ""
        enterNewPasswordView.textField.isSecureTextEntry = true
        enterNewPasswordView.textField.delegate = self
        
        enterConfirmNewPasswordView.textFieldTitle.text = "confirm password"
        enterConfirmNewPasswordView.textFieldTitleImage.isHidden = true
        enterConfirmNewPasswordView.textField.placeholder = ""
        enterConfirmNewPasswordView.textField.isSecureTextEntry = true
        enterConfirmNewPasswordView.textField.delegate = self
    }
    
    func setupSaveButton() {
        btnSaveNewPassword.btnCustomLabel.text = "save"
        btnSaveNewPassword.btnCustomClick.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    
    @objc func saveTapped() {
        validateAndCallAPI()
    }
    
    func validateAndCallAPI() {
        let password  = enterNewPasswordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cpassword = enterConfirmNewPasswordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // ─── Validation ───────────────────────────────────────────
        
        if password.isEmpty && cpassword.isEmpty {
            showError("Please Enter Password and Confirm Password")
            return
        }
        
        if password.isEmpty {
            showError("Please Enter New Password")
            return
        }
        
        if cpassword.isEmpty {
            showError("Please Enter Confirm Password")
            return
        }
        
        if !isValidPassword(password) {
            showError("Password must have 8+ chars, upper, lower, number & special character")
            return
        }
        
        if password != cpassword {
            showError("Password Does Not Match")
            return
        }
        
        guard let email = email, let token = resetToken else {
            showError("Something went wrong. Please try again.")
            return
        }
        
      
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Saving new password...", colorStyle: 0xFFD110)
        
        APIManager.shared.resetPassword(email: email, token: token, password: password) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                
                if let error = error {
                    self?.showError(error)
                    return
                }
                
                if response?.code == 200 {
                    self?.navigateToLogin()
                    SCLAlertView().showSuccess(response?.message ?? "", subTitle: "")
                } else {
                    self?.showError(response?.message ?? "Reset Password Failed")
                }
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    private func navigateToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showError(_ message: String) {
        SCLAlertView().showError(message, subTitle: "")
    }
}
extension ResetPasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterNewPasswordView.textField {
            enterConfirmNewPasswordView.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            validateAndCallAPI()
        }
        return true
    }
}
