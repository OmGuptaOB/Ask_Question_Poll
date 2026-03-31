//
//  ResponseModels.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 30/03/26.
//

import ObjectMapper

//MARK: Login Response Model
class LoginResponseModel: Mappable {
    
    var code: Int?
    var message: String?
    var cause: String?
    var data: LoginData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}
class LoginData: Mappable {
    
    var token: String?
    var user_details: UserDetails?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        token        <- map["token"]
        user_details <- map["user_details"]
    }
}
class UserDetails: Mappable {
    
    var social_uid: String?
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email_id: String?
    var gender: String?
    var country: String?
    var profile_img_original: String?
    var profile_img_compress: String?
    var profile_img_thumbnail: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        social_uid              <- map["social_uid"]
        id                      <- map["id"]
        first_name              <- map["first_name"]
        last_name               <- map["last_name"]
        email_id                <- map["email_id"]
        gender                  <- map["gender"]
        country                 <- map["country"]
        profile_img_original    <- map["profile_img_original"]
        profile_img_compress    <- map["profile_img_compress"]
        profile_img_thumbnail   <- map["profile_img_thumbnail"]
    }
}

//MARK: Signup Response Model
class SignUpResponseModel: Mappable {
    
    var code:    Int?
    var message: String?
    var cause:   String?
    var data:    SignUpData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}

class SignUpData: Mappable {
    
    var userRegTempId: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userRegTempId <- map["user_reg_temp_id"]
    }
}

//MARK: Otp Response Model
class OTPResponseModel: Mappable{

    var code: Int?
    var message: String?
    var cause: String?
    var data: OTPData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}


class OTPData: Mappable {
    var token: String?
    var user:  OTPUserDetails?

    required init?(map: Map) {}

    func mapping(map: Map) {
        token <- map["token"]
        user  <- map["user"]
    }
}

class OTPUserDetails: Mappable {
    var first_name:    String?
    var last_name:     String?
    var email_id:      String?
    var gender:        String?
    var country:       String?
    var profile_img:   String?
    var compress_img:  String?
    var original_img:  String?
    var thumbnail_img: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        first_name    <- map["first_name"]
        last_name     <- map["last_name"]
        email_id      <- map["email_id"]
        gender        <- map["gender"]
        country       <- map["country"]
        profile_img   <- map["profile_img"]
        compress_img  <- map["compress_img"]
        original_img  <- map["original_img"]
        thumbnail_img <- map["thumbnail_img"]
    }
}

//MARK: forgot Password Response Response Model
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

//MARK: forgot Password Response Response Model
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

//MARK: reset Password Response Model
class ResetPasswordResponseModel: Mappable {
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

//MARK: Add Question Response Model
class AddQuestionResponseModel: Mappable {
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

//MARK: get All Question response model
class GetAllQuestionsResponseModel: Mappable {
    var code: Int?
    var message: String?
    var cause: String?
    var data: AllQuestionsData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        cause <- map["cause"]
        data <- map["data"]
    }
}

class AllQuestionsData: Mappable {
    var result: [QuestionModel] = []  // flat array directly
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            //  Manually unwrap [[Any]] → flat [QuestionModel]
            if let outerArray = map["result"].currentValue as? [[Any]] {
                result = outerArray.flatMap { innerArray in
                    Mapper<QuestionModel>().mapArray(JSONObject: innerArray) ?? []
                }
                print("Parsed questions count: \(result.count)")
            } else if let outerArray = map["result"].currentValue as? [Any] {
                // Fallback — if server returns flat array
                result = Mapper<QuestionModel>().mapArray(JSONObject: outerArray) ?? []
                print("Parsed questions count (flat): \(result.count)")
            }
        }
}

class QuestionModel: Mappable {
    var user_id: Int?
    var question_id: Int?
    var category_id: String?
    var country: String?
    var gender: String?
    var description: String?
    var question_compress: String?
    var question_original: String?
    var question_thumbnail: String?
    var option1: String?
    var option2: String?
    var option1_compress_image: String?
    var option1_original_image: String?
    var option1_thumbnail_image:String?
    var option2_compress_image: String?
    var option2_original_image: String?
    var option2_thumbnail_image:String?
    var option_type: Int?    // 1 = text, 2 = image
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        question_id <- map["question_id"]
        category_id <- map["category_id"]
        country <- map["country"]
        gender <- map["gender"]
        description <- map["description"]
        question_compress <- map["question_compress"]
        question_original <- map["question_original"]
        question_thumbnail <- map["question_thumbnail"]
        option1 <- map["option1"]
        option2 <- map["option2"]
        option1_compress_image <- map["option1_compress_image"]
        option1_original_image <- map["option1_original_image"]
        option1_thumbnail_image <- map["option1_thumbnail_image"]
        option2_compress_image <- map["option2_compress_image"]
        option2_original_image <- map["option2_original_image"]
        option2_thumbnail_image <- map["option2_thumbnail_image"]
        option_type <- map["option_type"]
    }
}

