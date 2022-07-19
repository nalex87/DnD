//
//  ClassesViewModel.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 14.07.2022.
//

import Foundation
import Alamofire
import Combine

class ClassesViewModel: ObservableObject {
    
    struct ClassesResponse: Decodable {
        struct Class: Decodable {
            let index: String
            let name: String
            let url: String
        }
        let count: Int
        let results: [Class]
    }

    struct ClassModel: Decodable {
        let index: String
        let name: String
    }

    @Published var classes: [ClassModel] = []
    @Published var isFetching: Bool = false
    
    private var networkManager: NetworkManager?
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchClasses()
    }
    
    func fetchClasses() {
        isFetching = true
        networkManager?.getClasses().responseDecodable(of: ClassesResponse.self) { (result: DataResponse<ClassesResponse, AFError>) in
            switch result.result {
            case .success(let response):
                self.classes = response.results.map{
                    ClassModel(index: $0.index, name: $0.name)
                }
            case .failure:
                print("Failure")
            }
            self.isFetching = false
        }
    }
    
}
