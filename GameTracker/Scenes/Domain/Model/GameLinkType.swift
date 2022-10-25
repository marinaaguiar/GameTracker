//
//  GameLinkType.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/24/22.
//

import Foundation

enum GameLinkType: Equatable, Hashable {
    case ruleGame
    case websiteGame

    static func allCases() -> [GameLinkType] {
        [.ruleGame,
         .websiteGame,
        ]
    }
}
