//
//  GameDetailDescriptionModel.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/4/22.
//

import Foundation

struct GameDetailDescriptionModel: Codable, Hashable {
    var isDescriptionExpanded: Bool = false
    let gameDetail: GameDetail
}
