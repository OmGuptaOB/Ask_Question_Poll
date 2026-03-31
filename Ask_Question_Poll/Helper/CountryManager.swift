//
//  CountryManager.swift
//  Ask_Question_Poll
//
//  Created by Antigravity on 25/03/26.
//

import Foundation
import ObjectMapper

class CountryManager {
    static let shared = CountryManager()
    
    var countries: [CountryModel] = []
    
    private init() {
        loadCountries()
    }
    
    private func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countryNames", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let jsonString = String(data: jsonData, encoding: .utf8),
              let response = CountryResponse(JSONString: jsonString)
        else { return }
        
        self.countries = response.country_JSON
    }
    
    func getCountryNames() -> [String] {
        return countries.compactMap { $0.name }
    }
}
