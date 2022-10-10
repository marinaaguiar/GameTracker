//
//  GameDetail.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/27/22.
//

import Foundation

class GameDetail: Codable, Hashable {
    let id: String
    let name: String
    let price: String
    let minAge: Int
    let description: String
    let descriptionPreview: String
    let yearPublished: Int
    let players: String
    let playtime: String

    init(id: String, name: String, price: String, minAge: Int, description: String, descriptionPreview: String, year: Int, players: String, playtime: String) {
        self.id = id
        self.name = name
        self.price = price
        self.minAge = minAge
        self.description = description
        self.descriptionPreview = descriptionPreview
        self.yearPublished = year
        self.players = players
        self.playtime = playtime
    }

    convenience init(gameResponse: GameResponse) {
        self.init(
            id: gameResponse.id,
            name: gameResponse.name,
            price: gameResponse.price,
            minAge: gameResponse.minAge!,
            description: gameResponse.description,
            descriptionPreview: gameResponse.descriptionPreview,
            year: gameResponse.yearPublished!,
            players: gameResponse.players!,
            playtime: gameResponse.playtime!
        )
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: GameDetail, rhs: GameDetail) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}

