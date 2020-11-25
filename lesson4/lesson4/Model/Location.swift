//
//  Location.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import Foundation

public struct Location: Codable, CustomStringConvertible {
    public var description: String {
        """
        self.id = \(id)
        self.name = \(name)
        self.type = \(type)
        self.dimension = \(dimension)
        self.url = \(url)
        self.created = \(created)
"""
    }
    
    
    public var id: Int64
    public var name: String
    public var type: String
    public var dimension: String
    public var url: String
    public var created: String
    
    public init(id: Int64, name: String, type: String, dimension: String, url: String, created: String) {
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.url = url
        self.created = created
    }
}
