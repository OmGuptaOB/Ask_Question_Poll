//
//  SelectFromPickerXIb.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 23/03/26.
//

import UIKit

class SelectFromPickerXIb: NibView {
    
    @IBOutlet weak var selectDataTextField: UITextField!
    
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    
    var onValueSelected: ((String) -> Void)?
    
    private var pickerView = UIPickerView()
    private var dataList: [String] = []
    
    private var selectedValue: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitle()
        setupPicker()
        selectDataTextField.tintColor = .clear 
    }
    
    func setupTitle() {
        selectDataTextField.font = UIFont(name: "SFAtarianSystemExtended", size: 20)
        noteDescriptionLabel.font = UIFont(name: "SFAtarianSystemExtended", size: 10)
        selectDataTextField.isEnabled = true       // keeps tap working
        selectDataTextField.isUserInteractionEnabled = true
    }
    
    func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        
        selectDataTextField.inputView = pickerView
        selectDataTextField.inputAccessoryView = toolbar
        selectDataTextField.tintColor = .clear // hides cursor
        
        selectDataTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
           selectDataTextField.text = selectedValue
       }
    
    // Call this to load data into picker
    func configure(with data: [String], placeholder: String = "Select") {
        dataList = data
        selectDataTextField.placeholder = placeholder
        pickerView.reloadAllComponents()
    }
    
    @objc private func doneTapped() {
        if !dataList.isEmpty {
            let index = pickerView.selectedRow(inComponent: 0)
            selectedValue = dataList[index]
            selectDataTextField.text = selectedValue
            onValueSelected?(selectedValue)
        }
        selectDataTextField.resignFirstResponder()
    }
}

extension SelectFromPickerXIb: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = dataList[row]
        selectDataTextField.text = selectedValue
        onValueSelected?(selectedValue)
    }
}
