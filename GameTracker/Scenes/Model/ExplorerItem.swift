//
//  Section.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/16/22.
//

import Foundation

class ExplorerItem: Hashable {
  let title: String
  let imageItems: [GameResponse]

  init(title: String, imageItems: [GameResponse] = []) {
    self.title = title
    self.imageItems = imageItems
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: ExplorerItem, rhs: ExplorerItem) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  private let identifier = UUID()
}
