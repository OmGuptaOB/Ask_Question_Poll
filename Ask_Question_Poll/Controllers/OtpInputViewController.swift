//
//  OtpInputViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import UIKit
import SCLAlertView

enum OTPScreenMode {
    case signUpOTP          // coming from signup — verify OTP
    case forgotPasswordEmail // coming from login — enter email first
    case forgotPasswordOTP  // after email verified — enter OTP
}

class OtpInputViewController: UIViewController {
    
    
    @IBOutlet weak var optTextFieldView: TextFieldXib!
    
    @IBOutlet weak var btnEnterOTpView: ButtonXib!
    
    
    var screenMode: OTPScreenMode = .signUpOTP
    var userRegTempId: Int?
    var forgotPasswordEmail: String?  // stores email after step 1
    
    var loader: SCLAlertViewResponder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupOTPtextField()
        //        setupEnterOtpButton()
        setupNav()
        configureScreen()
    }
    
    func configureScreen() {
        switch screenMode {
            
        case .signUpOTP:
            setupTextField(title: "otp", placeholder: "Enter otp", keyboardType: .numberPad)
            setupButton(title: "verify", action: #selector(verifySignUpOTP))
            
        case .forgotPasswordEmail:
            setupTextField(title: "email", placeholder: "Enter your registered email", keyboardType: .emailAddress)
            setupButton(title: "send otp", action: #selector(verifyForgotEmail))
            
        case .forgotPasswordOTP:
            setupTextField(title: "otp", placeholder: "Enter otp sent to email", keyboardType: .numberPad)
            setupButton(title: "verify", action: #selector(verifyForgotOTP))
        }
    }
    func setupTextField(title: String, placeholder: String, keyboardType: UIKeyboardType) {
        optTextFieldView.textFieldTitle.text = title
        optTextFieldView.textFieldTitleImage.isHidden = true
        optTextFieldView.textField.placeholder = placeholder
        optTextFieldView.textField.keyboardType = keyboardType
        optTextFieldView.textField.text = ""
        optTextFieldView.textField.delegate = self
    }
    
    func setupButton(title: String, action: Selector) {
        // ✅ Remove all existing targets first to avoid double firing
        btnEnterOTpView.btnCustomClick.removeTarget(nil, action: nil, for: .allEvents)
        btnEnterOTpView.btnCustomLabel.text = title
        btnEnterOTpView.btnCustomClick.addTarget(self, action: action, for: .touchUpInside)
    }
    
    
    //
    //    func setupOTPtextField(){
    //        if isforgotPassword {
    //            optTextFieldView.textFieldTitle.text = "Email"
    //            optTextFieldView.textFieldTitleImage.isHidden = true
    //            optTextFieldView.textField.keyboardType = .emailAddress
    //            optTextFieldView.textField.placeholder = "Enter Email"
    //            optTextFieldView.textField.delegate = self
    //        }else{
    //            optTextFieldView.textFieldTitle.text = "otp"
    //            optTextFieldView.textFieldTitleImage.isHidden = true
    //            optTextFieldView.textField.keyboardType = .numberPad
    //            optTextFieldView.textField.placeholder = "Enter OTP"
    //            optTextFieldView.textField.delegate = self
    //        }
    //
    //    }
    
    //    func setupEnterOtpButton(){
    //        if isforgotPassword{
    //            btnEnterOTpView.btnCustomLabel.text = "next"
    //            btnEnterOTpView.btnCustomClick.addTarget(self, action: #selector(verifyEmail), for: .touchUpInside)
    //        }else{
    //            btnEnterOTpView.btnCustomLabel.text = "ok"
    //            btnEnterOTpView.btnCustomClick.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
    //        }
    //
    //
    //    }
    func setupNav(){
        navigationController?.setupGlobalBackButton()
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.titleView?.backgroundColor = .clear
    }
    
    
    @objc func verifySignUpOTP() {
        let otp = optTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
        let email = optTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
                    self?.switchToForgotOTPMode()
                    SCLAlertView().showSuccess(response?.message ?? "Check your email for the OTP", subTitle: "")
                } else {
                    self?.showError(response?.message ?? "Failed to send OTP")
                }
            }
        }
    }
    
    // ─── Action 3: Forgot Password — Verify OTP ──────────────────
    
    @objc func verifyForgotOTP() {
        let otp = optTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
                    self?.navigateToResetPassword(email: email, resetToken: resetToken)
                } else {
                    self?.showError(response?.message ?? "OTP Verification Failed")
                }
            }
        }
    }
    
    // ─── Switch to OTP mode after email verified ──────────────────
    
    private func switchToForgotOTPMode() {
        //Update mode and reconfigure screen — no new VC push needed
        screenMode = .forgotPasswordOTP
        configureScreen()
    }
    
    private func navigateToResetPassword(email: String, resetToken: String) {
        // Pass both email and token to reset password screen
        let resetVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
         resetVC.email = email
         resetVC.resetToken = resetToken
         navigationController?.pushViewController(resetVC, animated: true)
        print("Navigate to reset password — email: \(email), token: \(resetToken)")
    }
    
    private func navigateToLogin() {
        SCLAlertView().showSuccess("Success", subTitle: "Account verified! Please login.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func showError(_ message: String) {
        SCLAlertView().showError(message, subTitle: "")
    }
}

extension OtpInputViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        switch screenMode {
        case .forgotPasswordEmail:
            return true  // no restriction on email field
        case .signUpOTP, .forgotPasswordOTP:
            return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            && newText.count <= 4
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch screenMode {
        case .signUpOTP:          verifySignUpOTP()
        case .forgotPasswordEmail: verifyForgotEmail()
        case .forgotPasswordOTP:  verifyForgotOTP()
        }
        return true
        
    }
}
