//
//  LocationPage.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import Foundation

public struct LocationPage: Codable {
    
    public var info: PageInfo
    public var results: [Location]
    
    public init(info: PageInfo, results: [Location]) {
        self.info = info
        self.results = results
    }
}
