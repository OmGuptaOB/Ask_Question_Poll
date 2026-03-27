//
//  ImagePickerXib.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import UIKit

class ImagePickerXib: NibView {
    @IBOutlet weak var imagePickerImage: UIImageView!
    @IBOutlet weak var btnClickOpenPicker: UIButton!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    
    // Parent gets notified here — just set this closure wherever you use it
    var onImageSelected: ((UIImage) -> Void)?
    
    //  Each instance holds its own picker — no interference between multiple pickers
    private var imagePicker: UIImagePickerController?
    private(set) var isImageSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerSetup()
    }
    
    func pickerSetup(){
        btnClickOpenPicker.addTarget(self, action: #selector(openPickerTapped), for: .touchUpInside)
        isImageSelected = false
    }
    
    // Finds the top-most VC automatically — works from any screen
    private func topViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while let presented = topVC?.presentedViewController {
            topVC = presented
        }
        return topVC
    }
    
    @objc private func openPickerTapped() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        // Camera option (only if available)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.openPicker(sourceType: .camera)
            } else {
                let errorAlert = UIAlertController(
                    title: "Camera Not Available",
                    message: "This device does not have a camera.",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
                    self.openPickerTapped()
                }))
                self.topViewController()?.present(errorAlert, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openPicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,y: self.view.bounds.midY,width: 0,height: 0)
            popover.permittedArrowDirections = []
        }
        
        topViewController()?.present(alert, animated: true)
    }
    
    private func openPicker(sourceType: UIImagePickerController.SourceType) {
        //  Each instance creates its own picker — fully isolated
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        self.imagePicker = picker
        topViewController()?.present(picker, animated: true)
    }
}

//  Delegate lives inside the XIB — nothing leaks to the parent VC
extension ImagePickerXib: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Use edited image if available, otherwise original
        let selectedImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self, let image = selectedImage else { return }
            
            //  Update image view directly
            self.imagePickerImage.image = image
            self.isImageSelected = true
            //  Notify parent with selected image
            self.onImageSelected?(image)
            
            // Clear picker reference
            self.imagePicker = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.imagePicker = nil
        }
    }
}
