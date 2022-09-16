//
//  ShoppingCart.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

import Foundation

struct ShoppingCart: Equatable, Identifiable {
  let id: UUID
  var items: [Item]

  static let empty = ShoppingCart(id: UUID(), items: [])

  mutating func add(item: Item) {
    self.items.append(item)
  }
}
