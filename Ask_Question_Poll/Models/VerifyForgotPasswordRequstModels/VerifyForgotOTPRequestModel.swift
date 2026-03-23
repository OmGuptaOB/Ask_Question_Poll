//
//  VerifyForgotOTPRequestModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import Foundation
import ObjectMapper

class VerifyForgotOTPRequestModel: Mappable {
    var email_id: String?
    var token:    Int?
    
    init(email: String, token: Int) {
        self.email_id = email
        self.token    = token
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        token    <- map["token"]
    }
}
