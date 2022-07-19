//
//  ClassDetailsViewModel.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 14.07.2022.
//

import Foundation
import Alamofire
import Combine

class ClassDetailsViewModel: ObservableObject {

    struct SpellsResponse: Decodable {
        struct Spell: Decodable {
            let index: String
            let name: String
            let url: String
        }
        let count: Int
        let results: [Spell]
    }

    struct SpellModel: Decodable {
        let index: String
        let name: String
    }

    @Published var spells: [SpellModel] = []
    @Published var isFetching: Bool = false
    
    private var networkManager: NetworkManager?
    
    init(classIndex: String, networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchSpells(for: classIndex)
    }
    
    func fetchSpells(for classIndex: String) {
        isFetching = true
        networkManager?.getSpells(for: classIndex).responseDecodable(of: SpellsResponse.self) { (result: DataResponse<SpellsResponse, AFError>) in
            switch result.result {
            case .success(let response):
                self.spells = response.results.map{
                    SpellModel(index: $0.index, name: $0.name)
                }
            case .failure:
                print("Failure")
            }
            self.isFetching = false
        }
    }
    
}
