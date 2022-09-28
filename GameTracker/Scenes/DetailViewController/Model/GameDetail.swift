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
    let description: String
    let yearPublished: Int

    init(id: String, name: String, price: String, description: String, year: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.yearPublished = year
    }

    convenience init(gameResponse: GameResponse) {
        self.init(
            id: gameResponse.id,
            name: gameResponse.name,
            price: gameResponse.price,
            description: gameResponse.description,
            year: gameResponse.yearPublished!
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
