//
//  Game.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/17/22.
//

import Foundation
import RealmSwift

class Game: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gameID: String = ""
    @Persisted var isOnWishlist: Bool = true
    convenience init(gameID: String, inOnWishlist: Bool = true) {
        self.init()
        self.gameID = gameID
    }
}
