//
//  VerifyForgotOTPResponseModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import Foundation
import ObjectMapper

class VerifyForgotOTPResponseModel: Mappable {
    var code:    Int?
    var message: String?
    var cause:   String?
    var data:    VerifyForgotOTPData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}

class VerifyForgotOTPData: Mappable {
    var token: String?  //  token for reset password API
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}
