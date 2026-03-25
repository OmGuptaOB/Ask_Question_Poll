//
//  LoginViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 18/03/26.
//

import UIKit
import SCLAlertView


class SignUpViewController: UIViewController {
//
    @IBOutlet weak var emailTextFieldView: TextFieldXib!
    @IBOutlet weak var passwordTextFieldView: TextFieldXib!
    @IBOutlet weak var confirmPasswordTextFieldView: TextFieldXib!
    @IBOutlet weak var countryTextFieldView: TextFieldXib!
    @IBOutlet weak var btnSignUpView: ButtonXib!
    @IBOutlet weak var imagePickerView: ImagePickerXib!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var radioMaleView: RadioXib!
    @IBOutlet weak var radioFemaleView: RadioXib!
    @IBOutlet weak var backGroundView: BackGroundViewXib!
    
    
    //MARK: Properties Declared
    var loader: SCLAlertViewResponder?
    var selectedGender: String = "male" // default
    let pickerView = UIPickerView()
    
    var selectedCountry: CountryModel?
    
    
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Function calls
        setupCountrySelect()
        setupBtnSignUp()
        setupEmailtextField()
        setupPasswordTextField()
        setupDefaultNav()
        setupProfileImagePicker()
        setupGenderRadio()
        setupCountryPicker()
        
        //MARK: Delegate
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
        confirmPasswordTextFieldView.textField.delegate = self
        countryTextFieldView.textField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self

        
        for fontfamily in UIFont.fontNames(forFamilyName: "SF Atarian System Extended") {
            print(fontfamily)
        }
        
        //MARK: Background colour set
        emailTextFieldView.backgroundColor = .clear
        passwordTextFieldView.backgroundColor = .clear
        confirmPasswordTextFieldView.backgroundColor = .clear
        countryTextFieldView.backgroundColor = .clear
        btnSignUpView.backgroundColor = .clear
        imagePickerView.backgroundColor = .clear
        radioMaleView.backgroundColor = .clear
        radioFemaleView.backgroundColor = .clear
        
        //MARK: Notification for Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    //MARK: imagepicker setup
    func setupProfileImagePicker(){
        imagePickerView.cameraIconImageView.isHidden = true
        imagePickerView.imagePickerImage.layer.cornerRadius = imagePickerView.imagePickerImage.frame.height / 2
        imagePickerView.imagePickerImage.clipsToBounds = true
        imagePickerView.imagePickerImage.contentMode = .scaleAspectFill
        imagePickerView.imagePickerImage.image = UIImage(named: "profile_avtar")
        imagePickerView.onImageSelected = { image in
            print("Profile image selected: \(image)")
        }
    }

    //MARK: textFields setup
    func setupEmailtextField(){
        emailTextFieldView.textFieldTitle.text = "email"
        emailTextFieldView.textField.placeholder = "Enter Email"
        emailTextFieldView.textField.text = "vaferam713@onbap.com"
        emailTextFieldView.textFieldTitleImage.isHidden = true
        emailTextFieldView.textField.keyboardType = .emailAddress
    }
    
    func setupPasswordTextField(){
        passwordTextFieldView.textFieldTitle.text = "password"
        passwordTextFieldView.textField.text = "123456789@Ob"
        passwordTextFieldView.textFieldTitleImage.isHidden = true
        passwordTextFieldView.textField.placeholder = "Enter Password"
        passwordTextFieldView.textField.isSecureTextEntry = true
        
        
        confirmPasswordTextFieldView.textFieldTitle.text = "confirm password"
//        confirmPasswordTextFieldView.textField.text = confirmPasswordTextFieldView.textField.text
        confirmPasswordTextFieldView.textField.text = "123456789@Ob"
        confirmPasswordTextFieldView.textFieldTitleImage.isHidden = true
        confirmPasswordTextFieldView.textField.placeholder = "Enter Confirm Password"
        confirmPasswordTextFieldView.textField.isSecureTextEntry = true
    }
    
    func setupCountrySelect(){
        countryTextFieldView.textFieldTitle.text = "country"
        countryTextFieldView.textField.placeholder = "Select Country"
        countryTextFieldView.textField.text = ""
        countryTextFieldView.textFieldInsideImage.image = UIImage(named: "dropdown_icon")
        countryTextFieldView.textFieldTitleImage.isHidden = true
        countryTextFieldView.textField.tintColor = .clear
    }
    
    //MARK: Signup Button set
    func setupBtnSignUp(){
        btnSignUpView.btnCustomLabel.text = "signup"
        btnSignUpView.btnCustomClick.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    //MARK: Api call Validation
    func validateAndCallAPI() {
        
        let email    = emailTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let cpassword = confirmPasswordTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let country  = countryTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let emailEmpty    = email.isEmpty
        let passwordEmpty = password.isEmpty
        let cpassEmpty    = cpassword.isEmpty
        let countryEmpty = country.isEmpty

        let emptyCount = [emailEmpty, passwordEmpty, cpassEmpty, countryEmpty].filter { $0 }.count

        // ─── Format Validations (all fields filled) ────────────────

        if !email.isValidEmail {
            showError("Please Enter Valid Email")
            return
        }

        if password.count < 6 {
            showError("Password Must Be At Least 6 Characters")
            return
        }

        if password != cpassword {
            showError("Password Does Not Match")
            return
        }
        
        if !password.isValidPassword {
            showError("Password must have 8+ chars, upper, lower, number & special character")
            return
        }
        
        guard imagePickerView.isImageSelected else {
            showError("Please Select Profile Image")
            return
        }

        // ─── All Good — Show Loader & Call API ────────────────────

        loader = showLoading(message: "Creating account...")

          // Pass selected image from your ImagePickerXib
          let request = SignUpRequestModel(
              email:      email,
              password:   password,
              country:    country,
              gender:     selectedGender,   // "male" or "female" → converted to 1/2 inside model
              profileImg: imagePickerView.imagePickerImage.image  // grabbed directly from your xib
          )

          APIManager.shared.signUp(request: request) { [weak self] response, error in
              DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                  self?.loader?.close()

                  if let error = error {
                      self?.showError(error)
                      return
                  }

                  if response?.code == 200 {
                      let tempId = response?.data?.userRegTempId ?? 0
                      SCLAlertView().showSuccess(response?.message ?? "ThankYou from confirming your account and opt has been sent to your email", subTitle: "")
                      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                             self?.navigateToOTP(tempId: tempId)
                         }
                  } else {
                      self?.showError(response?.message ?? "Sign Up Failed")
                  }
              }
          }
    }
     func navigateToOTP(tempId: Int) {
         let otpVC = OtpInputAndPasswordStoryBoard.instantiateViewController(withIdentifier: "OtpInputViewController") as! OtpInputViewController
         otpVC.userRegTempId = tempId
        navigationController?.pushViewController(otpVC, animated: true)
    }

    
    //MARK: Radio button
    func setupGenderRadio() {
        lblGender.font = UIFont(name: "SFAtarianSystemExtended", size: 24)
            radioMaleView.radioTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
            radioFemaleView.radioTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        radioMaleView.radioTitle.text = "male"
        radioFemaleView.radioTitle.text = "female"
        
        // Set default selection
        radioMaleView.setSelected(true)
        radioFemaleView.setSelected(false)
        
        //When male tapped — select male, deselect female
        radioMaleView.onSelected = { [weak self] in
            guard let self = self else { return }
            self.selectedGender = "male"
            self.radioMaleView.setSelected(true)
            self.radioFemaleView.setSelected(false)
            print("selected gender \(self.selectedGender)")
        }
        
        // When female tapped — select female, deselect male
        radioFemaleView.onSelected = { [weak self] in
            guard let self = self else { return }
            self.selectedGender = "female"
            self.radioMaleView.setSelected(false)
            self.radioFemaleView.setSelected(true)
            print("selected gender \(self.selectedGender)")
        }
    }
    
    //MARK: picker handlr
    func openCountryPicker() {
        countryTextFieldView.textField.becomeFirstResponder()
    }
    
    
    func setupCountryPicker() {
        // Attach picker as input view to the text field
        countryTextFieldView.textField.inputView = pickerView
        
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn   = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(countryPickerDoneTapped))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        countryTextFieldView.textField.inputAccessoryView = toolbar
        
        // Set default selection
        let countries = CountryManager.shared.countries
        countryTextFieldView.textField.text = countries.first?.name
        selectedCountry = countries.first
    }
    @objc func countryPickerDoneTapped() {
        countryTextFieldView.textField.resignFirstResponder()
    }
    
    
    // MARK: - Keyboard Observers
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        let fieldMaxY = view.firstResponder?.convert(view.firstResponder!.bounds, to: view).maxY ?? 0
        let overlap = fieldMaxY - (view.frame.height - keyboardFrame.height) + 16

        guard overlap > 0 else { return }

        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -overlap)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = .identity
        }
    }

    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


//MARK: Extension
extension SignUpViewController : UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryManager.shared.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let countries = CountryManager.shared.countries
        return "\(countries[row].name ?? "India") (\(countries[row].dial_code ?? "no code avaialabe"))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countries = CountryManager.shared.countries
        selectedCountry = countries[row]
        countryTextFieldView.textField.text = "\(countries[row].name ?? "India") (\(countries[row].dial_code ?? "no code availabe"))"
    }
    
    
    @objc func signUpTapped(){
        print("sign up Tapped")
        validateAndCallAPI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextFieldView.textField {
            passwordTextFieldView.textField.becomeFirstResponder()
        }else if textField == passwordTextFieldView.textField {
            confirmPasswordTextFieldView.textField.becomeFirstResponder()
        }else if textField == confirmPasswordTextFieldView.textField {
            countryTextFieldView.textField.becomeFirstResponder()
        }else if textField == countryTextFieldView.textField {
            countryTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTextFieldView.textField {
            openCountryPicker()
            textField.selectedTextRange = nil
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == countryTextFieldView.textField {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == countryTextFieldView.textField {
            textField.selectedTextRange = nil
        }
    }
    
    
}
