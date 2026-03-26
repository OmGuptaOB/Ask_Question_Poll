//
//  UserDefaultsManager.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    static var isQuestionAdded = false
    
    private enum Keys {
        static let token     = "user_token"
        static let isLoggedIn = "is_logged_in"
    }
    
    // ─── Token ────────────────────────────────────────────────────
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: Keys.token) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.token) }
    }
    
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    // ─── Save on login ────────────────────────────────────────────
    
    func saveLoginData(token: String) {
        self.token      = token
        self.isLoggedIn = true
    }
    
    // ─── Clear on logout ──────────────────────────────────────────
    
    func clearLoginData() {
        self.token      = nil
        self.isLoggedIn = false
    }
}
