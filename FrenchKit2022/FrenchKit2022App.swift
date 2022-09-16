//
//  FrenchKit2022App.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 16/09/2022.
//

import StateMachinePackage
import SwiftUI

func makeViewStateMachine(initialState: SupermarketState) -> ViewStateMachine<SupermarketState, SupermarketEvent> {
  let updateStock = UpdateStock { cart in
    print("side effect: updating the stock ...")
    try await Task.sleep(nanoseconds: 2_000_000_000)
    print("side effect: the stock has been updated!")
  }

  let updateCustomerQueue = UpdateCustomerQueue {
    print("side effect: updating the customer queue ...")
    try await Task.sleep(nanoseconds: 1_000_000_000)
    print("side effect: the customer queue has been updated!")
  }

  let executeTransaction = ExecuteTransaction { price, creditCard in
    // TODO: this is the real "execute transaction" side effect
    // in the real world it could be a call to a bank API
    // here we can fake it by waiting for a few seconds and logging the beginning and ending of the side effect.
    // we can also return a random boolean to simulate the success or failure of the transaction

    // MARK: < PUT YOUR CODE HERE >

    return true // -> replace by a random bool to make it funnier
  }

  let supermarketStateMachine = makeSupermarketStateMachine(
    initialState: initialState,
    updateStock: updateStock,
    updateCustomerQueue: updateCustomerQueue,
    executeTransaction: executeTransaction
  )

  return ViewStateMachine(stateMachine: supermarketStateMachine)
}

@main
struct FrenchKit2022App: App {
  var body: some Scene {
    WindowGroup {
      ContentView(stateMachine: makeViewStateMachine(initialState: .fillingInTheCart(.empty)))
    }
  }
}
