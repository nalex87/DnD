//
//  ClassDetailViewModel.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 15.07.2022.
//

import Foundation

import Foundation
import Alamofire
import Combine

class ClassDetailViewModel: ObservableObject {

    struct SpellDetailResponse: Decodable {
        let index: String
        let name: String
        let desc: [String]
    }

    @Published var spellDescriptions: [String] = []
    @Published var isFetching: Bool = false
    
    private var networkManager: NetworkManager?
    
    init(spellIndex: String, networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchSpellDetails(for: spellIndex)
    }
    
    func fetchSpellDetails(for spellIndex: String) {
        isFetching = true
        networkManager?.getSpellDescription(for: spellIndex).responseDecodable(of: SpellDetailResponse.self) { (result: DataResponse<SpellDetailResponse, AFError>) in
            switch result.result {
            case .success(let response):
                self.spellDescriptions = response.desc
            case .failure:
                print("Failure")
            }
            self.isFetching = false
        }
    }

}
