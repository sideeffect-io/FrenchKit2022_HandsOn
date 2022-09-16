//
//  StateMachine.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

import StateMachinePackage

func makeSupermarketStateMachine(
  initialState: SupermarketState,
  updateStock: UpdateStock,
  updateCustomerQueue: UpdateCustomerQueue,
  executeTransaction: ExecuteTransaction
) -> StateMachine<SupermarketState, SupermarketEvent> {
  StateMachine(initial: initialState) { state, event in
    switch (state, event) {
      // here is a first transition as an example
      case (.fillingInTheCart(var cart), .itemWasAdded(let item)):
        cart.add(item: item)
        return .newState(.fillingInTheCart(cart), output: updateStock(for: cart))

        // TODO: implement all the meaningful transitions according to the diagram in the README (statemachine.png)

        // MARK: < PUT YOUR CODE HERE >

      case (_, .reset):
        return .newState(.fillingInTheCart(.empty))

      default:
        return .sameState()
    }
  }
}
