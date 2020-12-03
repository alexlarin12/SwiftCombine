//
//  NetworkError.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import Foundation

enum NetworkError: LocalizedError {
        
     case unreachableAddress(url: URL)
     case invalidResponse
        
     var errorDescription: String? {
         switch self {
         case .unreachableAddress(let url): return "\(url.absoluteString) is unreachable"
         case .invalidResponse: return "Response with mistake"
         }
     }
}
