//
//  String+Validation.swift
//  Ask_Question_Poll
//
//  Created by Antigravity on 25/03/26.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
