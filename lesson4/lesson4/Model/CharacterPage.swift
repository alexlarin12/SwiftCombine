//
//  CharacterPage.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import Foundation

public struct CharacterPage: Codable {
    
    public var info: PageInfo
    public var results: [Character]
    
    public init(info: PageInfo, results: [Character]) {
        self.info = info
        self.results = results
    }
}
