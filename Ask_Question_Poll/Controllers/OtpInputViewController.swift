//
//  OtpInputViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import UIKit
import SCLAlertView

enum OTPScreenMode {
    case signUpOTP              // OTP only
    case forgotPasswordEmail    // Email only
    case forgotPasswordOTP      // OTP only
    case resetPassword          // New Password + Confirm Password
}

class OtpInputViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: TextFieldXib!
    @IBOutlet weak var btnEnterOTpView: ButtonXib!
    @IBOutlet weak var secondTextField: TextFieldXib!
    @IBOutlet weak var stackView: UIStackView!
    
    var screenMode: OTPScreenMode = .signUpOTP
    var userRegTempId: Int?
    var forgotPasswordEmail: String?
    var resetToken:String?
    var loader: SCLAlertViewResponder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        configureScreen()
    }
    
    func configureScreen() {
        switch screenMode {
            
        case .signUpOTP:
            showFields(first: true, second: false)
            setupFirstField(title: "otp", placeholder: "Enter OTP", keyboard: .numberPad, secure: false)
            setupButton(title: "verify", action: #selector(verifySignUpOTP))
            
        case .forgotPasswordEmail:
            showFields(first: true, second: false)
            setupFirstField(title: "email", placeholder: "Enter your registered email", keyboard: .emailAddress, secure: false)
            setupButton(title: "send otp", action: #selector(verifyForgotEmail))
            
        case .forgotPasswordOTP:
            showFields(first: true, second: false)
            setupFirstField(title: "otp", placeholder: "Enter OTP sent to email", keyboard: .numberPad, secure: false)
            setupButton(title: "verify", action: #selector(verifyForgotOTP))
            
        case .resetPassword:
            showFields(first: true, second: true)
            setupFirstField(title: "new password", placeholder: "Enter new password", keyboard: .default, secure: true)
            setupSecondField(title: "confirm password", placeholder: "Enter confirm password", keyboard: .default, secure: true)
            setupButton(title: "save", action: #selector(saveNewPassword))
        }
    }
    
    func showFields(first: Bool, second: Bool) {
          firstTextField.isHidden  = !first
          secondTextField.isHidden = !second
          stackView.layoutIfNeeded()
      }
    
    func setupFirstField(title: String, placeholder: String, keyboard: UIKeyboardType, secure: Bool) {
            firstTextField.textFieldTitle.text = title
            firstTextField.textFieldTitleImage.isHidden = true
            firstTextField.textField.placeholder = placeholder
            firstTextField.textField.keyboardType = keyboard
            firstTextField.textField.isSecureTextEntry = secure
            firstTextField.textField.text = ""
            firstTextField.textField.delegate = self
        }

        func setupSecondField(title: String, placeholder: String, keyboard: UIKeyboardType, secure: Bool) {
            secondTextField.textFieldTitle.text  = title
            secondTextField.textFieldTitleImage.isHidden = true
            secondTextField.textField.placeholder = placeholder
            secondTextField.textField.keyboardType = keyboard
            secondTextField.textField.isSecureTextEntry = secure
            secondTextField.textField.text = ""
            secondTextField.textField.delegate = self
        }
    
    func setupButton(title: String, action: Selector) {
            btnEnterOTpView.btnCustomClick.removeTarget(nil, action: nil, for: .allEvents)
            btnEnterOTpView.btnCustomLabel.text = title
            btnEnterOTpView.btnCustomClick.addTarget(self, action: action, for: .touchUpInside)
        }
    
    func setupNav(){
        navigationController?.setupGlobalBackButton()
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.titleView?.backgroundColor = .clear
    }
    
    
    @objc func verifySignUpOTP() {
        let otp = firstTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if otp.isEmpty {
            showError("Please Enter OTP")
            return
        }
        
        guard let otpInt = Int(otp) else {
            showError("Please Enter Valid OTP")
            return
        }
        
        guard let tempId = userRegTempId else {
            showError("Something went wrong. Please sign up again.")
            return
        }
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Verifying OTP...", colorStyle: 0xFFD110)
        
        let request = OTPRequestModel(
            user_reg_temp_id: "\(tempId)",
            token: otpInt
        )
        
        APIManager.shared.verifyUser(request: request) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                
                if let error = error {
                    self?.showError(error)
                    return
                }
                
                if response?.code == 200 {
                    self?.navigateToLogin()
                } else {
                    self?.showError(response?.message ?? "OTP Verification Failed")
                }
            }
        }
    }
    
    
    @objc func verifyForgotEmail() {
        let email = firstTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if email.isEmpty { showError("Please Enter Email"); return }
        
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        if !emailRegex.evaluate(with: email) { showError("Please Enter Valid Email"); return }
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Sending OTP...", colorStyle: 0xFFD110)
        
        APIManager.shared.forgotPassword(email: email) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                if let error = error { self?.showError(error); return }
                
                if response?.code == 200 {
                    self?.forgotPasswordEmail = email
                    self?.screenMode = .forgotPasswordOTP
                    self?.configureScreen()
                    SCLAlertView().showSuccess(response?.message ?? "Check your email for the OTP", subTitle: "")
                } else {
                    self?.showError(response?.message ?? "Failed to send OTP")
                }
            }
        }
    }
    
    // ─── Action 3: Forgot Password — Verify OTP ──────────────────
    
    @objc func verifyForgotOTP() {
        let otp = firstTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if otp.isEmpty { showError("Please Enter OTP"); return }
        guard let otpInt = Int(otp) else { showError("Please Enter Valid OTP"); return }
        guard let email = forgotPasswordEmail else { showError("Something went wrong."); return }
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Verifying OTP...", colorStyle: 0xFFD110)
        
        APIManager.shared.verifyForgotOTP(email: email, otp: otpInt) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                if let error = error { self?.showError(error); return }
                
                if response?.code == 200 {
                    // Save reset token for use in reset password screen
                    let resetToken = response?.data?.token ?? ""
                    self?.screenMode = .resetPassword
                    self?.configureScreen()
//                    self?.navigateToResetPassword(email: email, resetToken: resetToken)
                } else {
                    self?.showError(response?.message ?? "OTP Verification Failed")
                }
            }
        }
    }
    
    
    @objc func saveNewPassword() {
        let password  = firstTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cpassword = secondTextField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if password.isEmpty && cpassword.isEmpty { showError("Please Enter Password and Confirm Password"); return }
        if password.isEmpty{
            showError("Please Enter New Password")
            return
        }
        if cpassword.isEmpty{
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
        
        guard let email = forgotPasswordEmail,
              let token = resetToken else {
            showError("Something went wrong. Please try again.")
            return
        }
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Saving new password...", colorStyle: 0xFFD110)
        
        APIManager.shared.resetPassword(email: email, token: token, password: password) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                if let error = error { self?.showError(error); return }
                
                if response?.code == 200 {
                    SCLAlertView().showSuccess(response?.message ?? "Password Reset Successfully", subTitle: "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
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

       func showError(_ message: String) {
           SCLAlertView().showError(message, subTitle: "")
       }
    
    private func navigateToLogin() {
        SCLAlertView().showSuccess("Success", subTitle: "Account verified! Please login.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension OtpInputViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        switch screenMode {
        case .forgotPasswordEmail,.resetPassword:
            return true  // no restriction on email field
        case .signUpOTP, .forgotPasswordOTP:
            return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            && newText.count <= 4
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if screenMode == .resetPassword && textField == firstTextField.textField {
            secondTextField.textField.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        switch screenMode {
        case .signUpOTP:          verifySignUpOTP()
        case .forgotPasswordEmail: verifyForgotEmail()
        case .forgotPasswordOTP:  verifyForgotOTP()
        case .resetPassword:  saveNewPassword()
        }
        return true
        
    }
}
