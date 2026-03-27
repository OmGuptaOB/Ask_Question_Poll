//
//  HomeViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit
import SCLAlertView

enum PickingFor {
    case optionOne, optionTwo
}

class HomeViewController: UIViewController{
    
    
    @IBOutlet weak var selectCategoryPickerView: SelectFromPickerXIb!
    @IBOutlet weak var selectQuestionImageView: ImagePickerXib!
    @IBOutlet weak var writeDescriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var lblTextViewCharacterLimit: UILabel!
    @IBOutlet weak var radioTextOption: RadioXib!
    @IBOutlet weak var radioImageOption: RadioXib!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var labelPrefrences: UILabel!
    @IBOutlet weak var optionsView: OptionsTextandImageXib!
    @IBOutlet weak var locationPickerSelector: SelectFromPickerXIb!
    @IBOutlet weak var genderPickerSelector: SelectFromPickerXIb!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewButtonView: ButtonXib!
    @IBOutlet weak var submitButtonView: ButtonXib!
    
    
    var selectedOption: String?
    var countries: [CountryModel] = []
    var selectedCountry: CountryModel?
    var selectedGender: String?
    var loader: SCLAlertViewResponder?

    let categoryData: [String: Int] = [
        "World Affairs": 3,
        "Entertainment": 4,
        "Geography": 5,
        "History": 6,
        "Wildlife": 2,
        "Trending News": 1
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        setupImagePicker()
        setupRadioButtons()
        loadCountries()
        setupCategoryPicker()
        setupLocationPicker()
        setupGenderPicker()
        setupButton()
        
        writeDescriptionView.backgroundColor = .clear
        descriptionTextView.backgroundColor = .clear
        selectQuestionImageView.backgroundColor = .clear
        descriptionTextView.delegate = self
        
        //MARK: Notification for Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupButton() {
        previewButtonView.btnCustomLabel.setupButtonLabel(title: "preview",textColour: .black)
        previewButtonView.btnCustomClick.addTarget(self, action: #selector(previewTapped), for: .touchUpInside)
        
        submitButtonView.btnCustomLabel.setupButtonLabel(title: "submit",textColour: .black)
        submitButtonView.btnCustomClick.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    func setupFont(){
        labelPrefrences.font = UIFont(name: "SFAtarianSystemExtended", size: 17)
        labelQuestion.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        optionsLabel.font = UIFont(name: "SFAtarianSystemExtended", size: 17)
        labelDescription.font = UIFont(name: "SFAtarianSystemExtended", size: 17)
        lblTextViewCharacterLimit.font = UIFont(name: "SFAtarianSystemExtended", size: 14)
    }
    func setupImagePicker(){
//        selectQuestionImageView.imagePickerImage.image = nil
        //selectQuestionImageView.layer.borderWidth = 2
        //selectQuestionImageView.layer.borderColor = UIColor.white.cgColor
        selectQuestionImageView.contentMode = .scaleAspectFill
        
        selectQuestionImageView.onImageSelected = { image in
            print("Profile image selected: \(image)")
            self.selectQuestionImageView.cameraIconImageView.isHidden = true
        }
    }
    
    func setupRadioButtons(){
        radioTextOption.radioTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 22)
        radioImageOption.radioTitle.font = UIFont(name: "SFAtarianSystemExtended", size: 22)
        radioTextOption.radioTitle.textColor = .white
        radioImageOption.radioTitle.textColor = .white
        radioTextOption.radioTitle.text = "text"
        radioImageOption.radioTitle.text = "image"
        radioTextOption.setSelected(true)
        radioImageOption.setSelected(false)
        
        radioTextOption.onSelected = { [weak self] in
            guard let self = self else { return }
            self.selectedOption = "text"
            self.radioTextOption.setSelected(true)
            self.radioImageOption.setSelected(false)
            self.optionsView.optionOneView.setupForTextMode()
            self.optionsView.optionTwoView.setupForTextMode()
            print("selected option \(self.selectedOption)")
        }
        
        // When female tapped — select female, deselect male
        radioImageOption.onSelected = { [weak self] in
            guard let self = self else { return }
            self.selectedOption = "image"
            self.radioTextOption.setSelected(false)
            self.radioImageOption.setSelected(true)
            print("selected option \(self.selectedOption)")
            self.optionsView.optionOneView.setupForImageMode()
            self.optionsView.optionTwoView.setupForImageMode()
        }
    }
    
    func loadCountries() {
        // Handled by CountryManager.shared
    }
    
    func setupCategoryPicker(){
        selectCategoryPickerView.selectDataTextField.text = "select category"
        let sortedCategories = categoryData
            .sorted { $0.value < $1.value }
            .map { $0.key }
        selectCategoryPickerView.configure(with: sortedCategories, placeholder: "Select Category")
        selectCategoryPickerView.noteDescriptionLabel.isHidden = true
        selectCategoryPickerView.onValueSelected = { [weak self] value in
            print("Selected category: \(value)")
        }
    }
    
    // MARK: - Location Picker
    func setupLocationPicker() {
        locationPickerSelector.selectDataTextField.text = "select location"
        let countryNames = CountryManager.shared.getCountryNames()
        locationPickerSelector.configure(with: countryNames, placeholder: "Select Country")
        //        locationPickerSelector.noteDescriptionLabel.isHidden = true
        locationPickerSelector.setNoteText("Note: Your question will be visible at only selected locations")
        locationPickerSelector.onValueSelected = { [weak self] value in
            guard let self = self else { return }
            self.selectedCountry = CountryManager.shared.countries.first { $0.name == value }
            print("Selected country: \(self.selectedCountry?.name ?? "") \(self.selectedCountry?.dial_code ?? "")")
        }
    }
    
    // MARK: - Gender Picker
    func setupGenderPicker() {
        genderPickerSelector.selectDataTextField.text = "select gender"
        genderPickerSelector.configure(with: ["Male", "Female"], placeholder: "Select Gender")
        //        genderPickerSelector.noteDescriptionLabel.isHidden = true
        genderPickerSelector.setNoteText("Note: Your question will be visible to only selected genders")
        
        genderPickerSelector.onValueSelected = { [weak self] value in
            self?.selectedGender = value
            print("Selected gender: \(value)")
        }
    }
    
    func updateTextViewHeight(_ textView: UITextView, heightConstraint: NSLayoutConstraint, maxHeight: CGFloat = 120) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        heightConstraint.constant = min(estimatedSize.height, maxHeight)
    }
    
    // MARK: - Validation & API

    func validateAndSubmit() {
        let category = selectCategoryPickerView.selectDataTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let location = locationPickerSelector.selectDataTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let gender = genderPickerSelector.selectDataTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isTextMode = selectedOption == "text" || selectedOption == nil
        
        // ─── Empty check ──────────────────────────────────────────────
        let imageEmpty = !(selectQuestionImageView.isImageSelected)
        let categoryEmpty = category.isEmpty || category == "select category"
        let descriptionEmpty = description.isEmpty
        let locationEmpty = location.isEmpty || location == "select location"
        let genderEmpty = gender.isEmpty || gender == "select gender"
        
        // Text mode option checks
        let option1Text = optionsView.optionOneView.optiontextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option2Text = optionsView.optionTwoView.optiontextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Image mode option checks
        let option1Image = optionsView.optionOneView.optionImagePicker?.imagePickerImage.image
        let option2Image = optionsView.optionTwoView.optionImagePicker?.imagePickerImage.image
        
        // ─── All empty check ──────────────────────────────────────────
        if categoryEmpty && descriptionEmpty && locationEmpty && genderEmpty {
            showError("Please Enter All Details")
            return
        }
        
        // ─── Individual validations ───────────────────────────────────
        if categoryEmpty {
            showError("Choose Category")
            return
        }
        if descriptionEmpty {
            showError("Fill Description")
            return
        }
        
        if imageEmpty {
            showError("Select Question Image")
            return
        }
        
        if isTextMode {
            if option1Text.isEmpty {
                showError("Fill Option 1 Data")
                return
            }
            if option2Text.isEmpty {
                showError("Fill Option 2 Data")
                return
            }
        } else {
            if !(optionsView.optionOneView.isImageSelected) {
                showError("Select Option 1 Image")
                return
            }
            if !(optionsView.optionTwoView.isImageSelected) {
                showError("Select Option 2 Image")
                return
            }
        }
        
        if locationEmpty {
            showError("Select Country")
            return
        }
        if genderEmpty   {
            showError("Select Gender")
            return
        }
        
        // ─── Build request ────────────────────────────────────────────
        let categoryId = categoryData[category] ?? 0
        let genderInt  = gender == "Male" ? 1 : 2
        let optionType = isTextMode ? 1 : 2
        
        let request = AddQuestionRequestModel(
            categoryId: categoryId,
            country: selectedCountry?.name,
            gender: genderInt,
            description: description,
            optionType: optionType,
            option1: isTextMode ? option1Text : nil,
            option2: isTextMode ? option2Text : nil,
            questionImage: selectQuestionImageView.isImageSelected ? selectQuestionImageView.imagePickerImage.image : nil,
            optionOneImage: isTextMode ? nil : option1Image,
            optionTwoImage: isTextMode ? nil : option2Image
        )
        
        // ─── Show loader & call API ───────────────────────────────────
      loader = showLoading(message: "Submitting question...")
//        loader = SCLAlertView().showWait("Please wait", subTitle: "Submitting question...", colorStyle: 0xFCCF1C)
        
        APIManager.shared.addQuestion(request: request) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.loader?.close()
                
                if let error = error {
                    showError(error)
                    return
                }
                
                if response?.code == 200 {
                    showSuccess(response?.message ?? "Question added successfully!")
                    UserDefaultsManager.isQuestionAdded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.clearForm()
                    }
                } else {
                   showError(response?.message ?? "Failed to add question")
                }
            }
        }
    }

    // MARK: - Clear Form

    func clearForm() {
        // Text fields
        descriptionTextView.text = ""
        lblTextViewCharacterLimit.text = "0/200"

        // Pickers
        selectCategoryPickerView.selectDataTextField.text = "select category"
        locationPickerSelector.selectDataTextField.text = "select location"
        genderPickerSelector.selectDataTextField.text = "select gender"

        // Image picker
        selectQuestionImageView.imagePickerImage.image = UIImage(named: "img")
        selectQuestionImageView.cameraIconImageView.isHidden = false

        // Radio — reset to text mode
        radioTextOption.setSelected(true)
        radioImageOption.setSelected(false)
        selectedOption = "text"
        optionsView.optionOneView.setupForTextMode()
        optionsView.optionTwoView.setupForTextMode()

        // Clear option text views
        optionsView.optionOneView.optiontextView.text = ""
        optionsView.optionTwoView.optiontextView.text = ""
        
        updateTextViewHeight(descriptionTextView,
                             heightConstraint: descriptionTextViewHeightConstraint,
                             maxHeight: 40)
        
        if optionsView.optionOneView.optiontextView.text.isEmpty{
            optionsView.optionOneView.OptionNumberTitle.isHidden = false
            optionsView.optionOneView.optionCharacterLimit.isHidden = false
        }
        if optionsView.optionTwoView.optiontextView.text.isEmpty{
            optionsView.optionTwoView.OptionNumberTitle.isHidden = false
            optionsView.optionTwoView.optionCharacterLimit.isHidden = false
        }
        
    }
    
    
    func showPreview(){
        let isTextMode  = selectedOption == "text" || selectedOption == nil
        
        let previewData = AddQuestionRequestModel(
            categoryId: categoryData[selectCategoryPickerView.selectDataTextField.text ?? ""] ?? 0,
            country: selectedCountry?.name,
            gender: selectedGender == "Male" ? 1 : 2,
            description: descriptionTextView.text ?? "",
            optionType: isTextMode ? 1 : 2,
            option1: isTextMode ? optionsView.optionOneView.optiontextView.text : nil,
            option2: isTextMode ? optionsView.optionTwoView.optiontextView.text : nil,
            questionImage: selectQuestionImageView.isImageSelected ? selectQuestionImageView.imagePickerImage.image : nil,
            optionOneImage: isTextMode ? nil : optionsView.optionOneView.option_bg_image.image,
            optionTwoImage: isTextMode ? nil : optionsView.optionTwoView.option_bg_image.image
        )
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShowQuestionViewController") as! ShowQuestionViewController
        vc.previewData = previewData
        navigationController?.pushViewController(vc, animated: true)
    }


    @objc func submitTapped() {
        validateAndSubmit()
    }
    
    @objc func previewTapped() {
        guard canShowPreview() else { return }
        showPreview()
    }

    func canShowPreview() -> Bool {
        let description = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isTextMode  = selectedOption == "text" || selectedOption == nil
        let option1Text = optionsView.optionOneView.optiontextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let option2Text = optionsView.optionTwoView.optiontextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if description.isEmpty {
            showError("Fill Description to preview")
            return false
        }

        if isTextMode {
            if option1Text.isEmpty {
                showError("Fill Option 1 Data to preview")
                return false
            }
            if option2Text.isEmpty {
                showError("Fill Option 2 Data to preview")
                return false
            }
        } else {
            if !optionsView.optionOneView.isImageSelected {
                showError("Select Option 1 Image to preview")
                return false
            }
            if !optionsView.optionTwoView.isImageSelected {
                showError("Select Option 2 Image to preview")
                return false
            }
        }
        return true
    }
    
    
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
    

}

extension HomeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        if textView == descriptionTextView {
            lblTextViewCharacterLimit.text = "\(count)/200"
            updateTextViewHeight(textView, heightConstraint: descriptionTextViewHeightConstraint, maxHeight: .infinity)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         guard textView == descriptionTextView else { return true }
         
         let currentText = textView.text ?? ""
         guard let stringRange = Range(range, in: currentText) else { return false }
         let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if textView.text.count == 200 {
            showError("Limit reached you can only write 200 characters")
            textView.resignFirstResponder()
            return updatedText.count <= 200
        }
         return updatedText.count <= 200
     }
     
}




