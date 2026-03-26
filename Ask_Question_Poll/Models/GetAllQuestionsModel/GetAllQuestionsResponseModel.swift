//
//  GetAllQuestionsResponseModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import Foundation
import ObjectMapper

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
//    var result: [[QuestionModel]]?
//    
//    required init?(map: Map) {}
//    
//    func mapping(map: Map) {
//        result <- map["result"]
//    }
    
    var result: [QuestionModel] = []  // ✅ flat array directly
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            // ✅ Manually unwrap [[Any]] → flat [QuestionModel]
            if let outerArray = map["result"].currentValue as? [[Any]] {
                result = outerArray.flatMap { innerArray in
                    Mapper<QuestionModel>().mapArray(JSONObject: innerArray) ?? []
                }
                print("Parsed questions count: \(result.count)")
            } else if let outerArray = map["result"].currentValue as? [Any] {
                // ✅ Fallback — if server returns flat array
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
