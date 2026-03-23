//
//  ResetPasswordRequestModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import ObjectMapper

class ResetPasswordRequestModel: Mappable {
    var email_id: String?
    var token:    String?
    var password: String?
    
    init(email: String, token: String, password: String) {
        self.email_id = email
        self.token    = token
        self.password = password
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        token    <- map["token"]
        password <- map["password"]
    }
}
