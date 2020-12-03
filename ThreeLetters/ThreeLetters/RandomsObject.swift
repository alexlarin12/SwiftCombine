//
//  MonitorObject.swift
//  ThreeLetters
//
//  Created by Alex Larin on 02.12.2020.
//

import Foundation

class MonitorObject: ObservableObject {
    @Published var firstRandom: Character = "A"
    @Published var secondRandom: Character = "B"
    @Published var thirdRandom: Character = "C"
}
