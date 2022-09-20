//
//  SelfConfiguringCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/15/22.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: GameResponse)
}
