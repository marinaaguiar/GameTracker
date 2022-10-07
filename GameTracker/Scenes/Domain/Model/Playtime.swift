//
//  Playtime.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/3/22.
//

import Foundation

enum Playtime: Int, CaseIterable {
    case fifteenMin = 0
    case thirtyMin
    case fortyfiveMin
    case sixtyMin
    case ninetyMin
    case oneHundredTwentyMin
    case oneHundredEightyMin

    /// This number is used when calling the API
    /// as a reference for the given desired playtime
    /// when filtering by playtime.
    ///
    /// For instance, when we
    /// send `.fifteenMin`, we expect to receive all
    /// games with a playtime that's less than fifteen minutes.
    var number: Int {
        switch self {
        case .fifteenMin:
            return 15
        case .thirtyMin:
            return 30
        case .fortyfiveMin:
            return 45
        case .sixtyMin:
            return 60
        case .ninetyMin:
            return 90
        case .oneHundredTwentyMin:
            return 120
        case .oneHundredEightyMin:
            return 180
        }
    }

    var string: String {
        switch self {
        case .fifteenMin:
            return "15 min"
        case .thirtyMin:
            return "30 min"
        case .fortyfiveMin:
            return "45 min"
        case .sixtyMin:
            return "60 min"
        case .ninetyMin:
            return "90 min"
        case .oneHundredTwentyMin:
            return "120 min"
        case .oneHundredEightyMin:
            return "180 min"
        }
    }
}
