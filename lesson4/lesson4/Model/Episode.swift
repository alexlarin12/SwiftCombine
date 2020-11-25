//
//  Episode.swift
//  lesson4
//
//  Created by Alex Larin on 26.11.2020.
//

import Foundation

public struct Episode: Codable, CustomStringConvertible {
    public var description: String {
        """
        self.id = \(id)
        self.name = \(name)
        self.air_date = \(air_date)
        self.episode = \(episode)
        self.url = \(url)
        self.created = \(created)
"""
    }
    
    
    public var id: Int64
    public var name: String
    public var air_date: String
    public var episode: String
    public var url: String
    public var created: String
    
    public init(id: Int64, name: String, air_date: String, episode: String, url: String, created: String) {
        self.id = id
        self.name = name
        self.air_date = air_date
        self.episode = episode
        self.url = url
        self.created = created
    }
}
