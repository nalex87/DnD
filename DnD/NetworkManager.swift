//
//  NetworkManager.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 14.07.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let environmentEndpoin = "https://www.dnd5eapi.co/api"

    init() {
    }
    
    func getClasses() -> DataRequest {
        return AF.request("\(NetworkManager.environmentEndpoin)/classes")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
    }

    func getSpells(for classIndex: String) -> DataRequest {
        return AF.request("\(NetworkManager.environmentEndpoin)/classes/\(classIndex)/spells")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
    }

    func getSpellDescription(for spellIndex: String) -> DataRequest {
        return AF.request("\(NetworkManager.environmentEndpoin)/spells/\(spellIndex)")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
    }

}
