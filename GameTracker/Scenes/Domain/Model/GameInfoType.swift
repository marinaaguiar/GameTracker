//
//  GameInfoType.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/10/22.
//

import Foundation

enum GameInfoType: Equatable, Hashable {
    case numberOfPlayers(GameDetail)
    case playtime(GameDetail)
    case minAge(GameDetail)

    static func allCases(with game: GameDetail) -> [GameInfoType] {
        [.numberOfPlayers(game),
         .playtime(game),
         .minAge(game)
        ]
    }
}

