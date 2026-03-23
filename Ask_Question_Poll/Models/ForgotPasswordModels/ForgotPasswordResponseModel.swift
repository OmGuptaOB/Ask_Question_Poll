//
//  ForgotPasswordResponseModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//

import Foundation
import ObjectMapper

class ForgotPasswordResponseModel: Mappable {
    var code:    Int?
    var message: String?
    var cause:   String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
    }
}
