//
//  LoginViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit
import SCLAlertView


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFieldView: TextFieldXib!
    
    @IBOutlet weak var passwordTextFieldView: TextFieldXib!
    
    @IBOutlet weak var forgotPasswordView: LinkButtonXib!
    
    @IBOutlet weak var btnLoginview: ButtonXib!
    
    @IBOutlet weak var signUpBtnView: LinkButtonXib!
    
    var loader: SCLAlertViewResponder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupforgotPassword()
        setupSignUp()
        setupBtnLogin()
        setupEmailtextField()
        setupPasswordTextField()
        setupNav()
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
        
        
        for fontfamily in UIFont.fontNames(forFamilyName: "SF Atarian System Extended") {
            print(fontfamily)
        }
        
        emailTextFieldView.backgroundColor = .clear
        passwordTextFieldView.backgroundColor = .clear
        forgotPasswordView.backgroundColor = .clear
        btnLoginview.backgroundColor = .clear
        signUpBtnView.backgroundColor = .clear
    }
    
    
    func setupforgotPassword(){
        forgotPasswordView.btnForgotPassword.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
    }
    
    func setupSignUp(){
        signUpBtnView.btnForgotPassword.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        signUpBtnView.lblLinkText.text = "SIGNUP"
        signUpBtnView.lblLinkText.textAlignment = .center
    }
    func setupNav(){
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.titleView?.backgroundColor = .clear
    }

    func setupBtnLogin(){
        btnLoginview.btnCustomClick.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    func setupEmailtextField(){
        emailTextFieldView.textFieldTitle.text = "email"
        emailTextFieldView.textField.placeholder = "Enter email"
        emailTextFieldView.textField.text = "joya.tevbst@grr.la"
        emailTextFieldView.textFieldTitleImage.image = UIImage(named: "email_icon")
        emailTextFieldView.textField.keyboardType = .emailAddress
        
    }
    
    func setupPasswordTextField(){
        passwordTextFieldView.textFieldTitle.text = "password"
        
        passwordTextFieldView.textField.text = "demo"
        passwordTextFieldView.textFieldTitleImage.image = UIImage(named: "password_icon")
        passwordTextFieldView.textField.placeholder = "Enter password"
        
        passwordTextFieldView.textField.isSecureTextEntry = true
    }
    func validateAndCallAPI() {
        let email = emailTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if email.isEmpty && password.isEmpty {
            showError("Please Enter Information")
            return
        } else if email.isEmpty {
            showError("Please Enter Email")
            return
        }else if password.isEmpty {
            showError("Please Enter Password")
            return
        }
        
        loader = SCLAlertView().showWait("Please wait", subTitle: "Logging in...", colorStyle: 0xFCCF1C)
        
        
        let request = LoginRequestModel(email: email, password: password)
        
        APIManager.shared.login(request: request) { [weak self] response,error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self?.loader?.close()
                print("Code: \(String(describing: response?.code))")       // ← what code comes back?
                        print("Message: \(String(describing: response?.message))") // ← what message?
                        print("Data: \(String(describing: response?.data))")
                if let error = error {
                    self?.showError(error)
                    return
                }
                
                if response?.code == 200 {
                    self?.showSuccess()
                } else {
                    self?.showError(response?.message ?? "Login Failed")
                }
            }
            
        }
        
    }
    
    func showError(_ message: String) {
        SCLAlertView().showError(message, subTitle:"" )
    }
    func showSuccess() {
        SCLAlertView().showSuccess("Login Successful", subTitle: "")
        
    }
    
}

extension LoginViewController : UITextFieldDelegate{
    @objc func forgotTapped(){
        print("forgot password")
        let vc = storyboard?.instantiateViewController(withIdentifier: "OtpInputViewController") as! OtpInputViewController
        vc.screenMode = .forgotPasswordEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginTapped(){
        print("login password")
        validateAndCallAPI()
    }
    
    @objc func signUpTapped(){
        print("sign up tapped")
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextFieldView.textField{
            passwordTextFieldView.textField.becomeFirstResponder()
        }else{
            passwordTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
