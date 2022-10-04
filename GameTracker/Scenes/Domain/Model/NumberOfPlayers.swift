//
//  NumberOfPlayers.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/4/22.
//

import Foundation

enum NumberOfPlayers: Int, CaseIterable {
    case onePlayer = 0
    case twoPlayers
    case threePlayers
    case fourPlayers
    case fivePlusPlayers

    /// This number is used when calling the API
    /// as a reference for the given desired playtime
    /// when filtering by playtime.
    ///
    /// For instance, when we
    /// send `.twoPlayers`, we expect to receive all
    /// games for two number of players.

    var number: Int {
        switch self {
        case .onePlayer:
            return 1
        case .twoPlayers:
            return 2
        case .threePlayers:
            return 3
        case .fourPlayers:
            return 4
        case .fivePlusPlayers:
            return 5
        }
    }

    var string: String {
        switch self {
        case .onePlayer:
            return "1 player"
        case .twoPlayers:
            return "2 players"
        case .threePlayers:
            return "3 players"
        case .fourPlayers:
            return "4 players"
        case .fivePlusPlayers:
            return "5+ players"
        }
    }
}
