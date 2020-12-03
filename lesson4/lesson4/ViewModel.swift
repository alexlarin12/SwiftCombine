//
//  ViewModel.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import Foundation
import Combine

class ViewModel {
    internal init(
        apiClient: APIClient,
        inputIdentifiersPublisher: AnyPublisher<Int, Never>
    ) {
        self.apiClient = apiClient
       
        let networking1 = inputIdentifiersPublisher.map { apiClient.character(id: $0) }.switchToLatest().share()
        self.character = networking1.eraseToAnyPublisher()
        
        let networking2 = inputIdentifiersPublisher.map { apiClient.location(id: $0) }.switchToLatest().share()
        self.location = networking2.eraseToAnyPublisher()
        
        let networking3 = inputIdentifiersPublisher.map { apiClient.episode(id: $0) }.switchToLatest().share()
        self.episode = networking3.eraseToAnyPublisher()
    }
    
    let apiClient: APIClient
    let character: AnyPublisher<Character, NetworkError>
    let location: AnyPublisher<Location, NetworkError>
    let episode: AnyPublisher<Episode, NetworkError>
    
}
