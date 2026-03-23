//
//  CountryModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//
import ObjectMapper


class CountryModel: Mappable {
    
    var name: String?
    var dial_code: String?
    var code: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        name      <- map["name"]
        dial_code <- map["dial_code"]
        code      <- map["code"]
    }
}

class CountryResponse: Mappable {
    var country_JSON: [CountryModel] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        country_JSON <- map["country_JSON"]  // ✅ key must match JSON exactly
    }
}
