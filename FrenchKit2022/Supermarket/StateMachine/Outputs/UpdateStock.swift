//
//  UpdateStock.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

import StateMachinePackage

struct UpdateStock {
  // we capture a dependency to be able to use it in the side effect
  // we don't care if the dependency fails, it is a fire-and-forget side effect
  let updateStockInStorage: (ShoppingCart) async throws -> Void

  func callAsFunction(for shoppingCart: ShoppingCart) -> SideEffect<SupermarketEvent> {
    SideEffect {
      try? await self.updateStockInStorage(shoppingCart)
      return nil
    }
  }
}
