//
//  ExecuteTransactiont.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

import StateMachinePackage

struct ExecuteTransaction {
  // we capture a dependency to be able to use it in the side effect
  let submitPayment: (Price, CreditCard) async throws -> Bool

  func callAsFunction(for price: Price, and creditCard: CreditCard) -> SideEffect<SupermarketEvent> {
    // TODO: update the SideEffect by calling the dependency to execute the transaction
    // Be careful, this one can throw and the returned event depends on it (.paymentHasSucceeded or .paymentHasFailed)
    SideEffect {
      // MARK: < PUT YOUR CODE HERE >
      return nil
    }
  }
}
