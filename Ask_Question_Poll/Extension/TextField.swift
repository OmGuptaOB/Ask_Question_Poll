//
//  TextField.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 24/03/26.
//

import UIKit

class NoSelectTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        DispatchQueue.main.async {
            UIMenuController.shared.hideMenu()
        }
        return false
    }
    
    override var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: .standardEdit)
        builder.remove(menu: .text)
        builder.remove(menu: .lookup)
        builder.remove(menu: .share)
        super.buildMenu(with: builder)
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func paste(_ sender: Any?) { }
    override func selectAll(_ sender: Any?) { }
    override func select(_ sender: Any?) { }
    override func cut(_ sender: Any?) { }
    override func copy(_ sender: Any?) { }
    
    // 👇 Nuclear — remove ALL gestures except tap
    override func didMoveToWindow() {
        super.didMoveToWindow()
        removeUnwantedGestures()
    }
    
    private func removeUnwantedGestures() {
        gestureRecognizers?.forEach { gesture in
            if gesture is UILongPressGestureRecognizer {
                removeGestureRecognizer(gesture)  // 👈 fully remove, not just disable
            }
        }
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UILongPressGestureRecognizer {
            return  // 👈 never even add it
        }
        super.addGestureRecognizer(gestureRecognizer)
    }
    
    override func replace(_ range: UITextRange, withText text: String) { }

    override func insertText(_ text: String) { }
}
