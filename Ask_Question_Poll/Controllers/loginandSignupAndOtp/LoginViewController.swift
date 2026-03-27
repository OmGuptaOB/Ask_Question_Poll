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
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var btnLoginview: ButtonXib!
    @IBOutlet weak var signUpBtnView: UIView!
    @IBOutlet weak var labelForgotPassword: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    var loader: SCLAlertViewResponder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupforgotPassword()
        setupSignUp()
        setupBtnLogin()
        setupEmailtextField()
        setupPasswordTextField()
        setupDefaultNav()
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
        labelForgotPassword.setupTitle(size: 20,underline: true)
    }
    
    func setupSignUp(){
        lblSignUp.setupTitle(size: 20,underline: true)
    }

    func setupBtnLogin(){
        btnLoginview.btnCustomClick.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    func setupEmailtextField(){
        emailTextFieldView.textFieldTitle.text = "email"
        emailTextFieldView.textField.placeholder = "Enter Email"
        emailTextFieldView.textField.text = "sifila1565@fun4k.com"
        emailTextFieldView.textFieldTitleImage.image = UIImage(named: "email_icon")
        emailTextFieldView.textField.keyboardType = .emailAddress
    }
    
    func setupPasswordTextField(){
        passwordTextFieldView.textFieldTitle.text = "password"
        passwordTextFieldView.textField.text = "123456789@Ob"
        passwordTextFieldView.textFieldTitleImage.image = UIImage(named: "password_icon")
        passwordTextFieldView.textField.placeholder = "Enter Password"
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
        } else if !email.isValidEmail {
            showError("Please Enter Valid Email")
            return
        } else if password.isEmpty {
            showError("Please Enter Password")
            return
        }
        
        loader = showLoading(message: "Logging in...")
        
        let request = LoginRequestModel(email: email, password: password)
        
        APIManager.shared.login(request: request) { [weak self] response,error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self?.loader?.close()
                //use to debug response
//                print("Code: \(String(describing: response?.code))")       // ← what code comes back?
//                        print("Message: \(String(describing: response?.message))") // ← what message?
//                        print("Data: \(String(describing: response?.data))")
                if let error = error {
                    showError(error)
                    return
                }
                if response?.code == 200 {
                    if let token = response?.data?.token {
                            UserDefaultsManager.shared.saveLoginData(token: token)
                            print("Token saved: \(token)")
                        }
                    showSuccess(response?.message ?? "Login Successful")
                    self?.navigateToHome()
                } else {
                   showError(response?.message ?? "Login Failed")
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func BtnForgotPassword(_ sender: Any) {
        forgotTapped()
    }
    
    
    @IBAction func btnSignUp(_ sender: Any) {
        signUpTapped()
    }
    
}

extension LoginViewController : UITextFieldDelegate{
    func forgotTapped(){
        let vc = OtpInputAndPasswordStoryBoard.instantiateViewController(withIdentifier: "OtpInputViewController") as! OtpInputViewController
        vc.screenMode = .forgotPasswordEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginTapped(){
        print("login password")
        validateAndCallAPI()
    }
    
    func navigateToHome(){
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signUpTapped(){
        print("sign up tapped")
        let vc = SignUpStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
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
