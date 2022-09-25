//
//  ExploreModel.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/21/22.
//

import Foundation

struct ExploreModel: Identifiable, Hashable {
    var id: UUID = UUID()
    let gameResponse: GameResponse
    let complexityLevels = ["very easy, easy, moderate, difficult, very difficult"]

    enum ComplexityLevel: String, CaseIterable, Hashable {
        case veryEasy = "very easy"
        case easy = "easy"
        case moderate = "moderate"
        case difficult = "difficult"
        case veryDifficult = "very difficult"
    }

}
