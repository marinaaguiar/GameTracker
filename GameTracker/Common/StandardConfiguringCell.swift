//
//  StandardConfiguringCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/21/22.
//

import Foundation

protocol StandardConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure()
}
