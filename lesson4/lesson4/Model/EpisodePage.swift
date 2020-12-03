//
//  EpisodePage.swift
//  lesson4
//
//  Created by Alex Larin on 26.11.2020.
//

import Foundation

public struct EpisodePage: Codable {
    
    public var info: PageInfo
    public var results: [Episode]
    
    public init(info: PageInfo, results: [Episode]) {
        self.info = info
        self.results = results
    }
}
