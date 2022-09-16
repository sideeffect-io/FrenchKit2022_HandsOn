//
//  UpdateCustomerQueue.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

import StateMachinePackage

struct UpdateCustomerQueue {
  // we capture a dependency to be able to use it in the side effect
  // we don't care if the dependency fails, it is a fire-and-forget side effect
  let updateQueueInSystem: () async throws -> Void

  func callAsFunction() -> SideEffect<SupermarketEvent> {
    SideEffect {
      try? await self.updateQueueInSystem()
      return nil
    }
  }
}
