//
//  SupermarketTests.swift
//  FrenchKit2022Tests
//
//  Created by Thibault Wittemberg on 16/09/2022.
//

import XCTest
import StateMachinePackage
@testable import FrenchKit2022

final class SupermarketTests: XCTestCase {
  func test_stateMachine_performs_the_expected_transitions() async {
    let hasUpdatedStock = Spy(value: false)
    let hasUpdatedCustomerQueue = Spy(value: false)
    let hasExecutedTransaction = Spy(value: false)

    let spyUpdateStock = UpdateStock { _ in
      await hasUpdatedStock.set(value: true)
    }

    let spyUpdateCustomerQueue = UpdateCustomerQueue {
      await hasUpdatedCustomerQueue.set(value: true)
    }

    let spyExecuteTransaction = ExecuteTransaction { _, _ in
      await hasExecutedTransaction.set(value: true)
      return true
    }

    let systemUnderTest = makeSupermarketStateMachine(
      initialState: .fillingInTheCart(.empty),
      updateStock: spyUpdateStock,
      updateCustomerQueue: spyUpdateCustomerQueue,
      executeTransaction: spyExecuteTransaction
    )

    let initialShoppingCart = ShoppingCart.empty
    let item = Item(price: 3.5, name: "Item")
    let creditCart = CreditCard(number: "aaaa bbbb cccc dddd", pin: 1234)
    var updatedShoppingCart = initialShoppingCart
    updatedShoppingCart.add(item: item)

    // MARK: Meaningful transitions

    // fillingInTheCart + itemWasAdded => fillingInTheCart + updateStock
    await XCTAssert(
      systemUnderTest,
      when: .fillingInTheCart(initialShoppingCart),
      on: .itemWasAdded(item),
      transitionTo: .newState(.fillingInTheCart(updatedShoppingCart)),
      sideEffectAssert: { await hasUpdatedStock.value }
    )

    // fillingInTheCart + walkingToCashier => atTheCheckout + updateCustomerQueue
    await XCTAssert(
      systemUnderTest,
      when: .fillingInTheCart(updatedShoppingCart),
      on: .walkingToCashier,
      transitionTo: .newState(.atTheCheckout(updatedShoppingCart)),
      sideEffectAssert: { await hasUpdatedCustomerQueue.value }
    )

    // atTheCheckout + givingMyCreditCard => paying + executeTransaction
    await XCTAssert(
      systemUnderTest,
      when: .atTheCheckout(updatedShoppingCart),
      on: .givingMyCreditCard(creditCart),
      transitionTo: .newState(.paying(updatedShoppingCart, creditCart, 3.5)),
      sideEffectAssert: { await hasExecutedTransaction.value }
    )

    // paying + paymentHasSucceeded => goingHomeHappy + no output
    await XCTAssert(
      systemUnderTest,
      when: .paying(updatedShoppingCart, creditCart, 3.5),
      on: .paymentHasSucceeded,
      transitionTo: .newState(.goingHomeHappy(updatedShoppingCart))
    )

    // paying + paymentHasFailed => goingHomeSad + no output
    await XCTAssert(
      systemUnderTest,
      when: .paying(updatedShoppingCart, creditCart, 3.5),
      on: .paymentHasFailed,
      transitionTo: .newState(.goingHomeSad(updatedShoppingCart))
    )

    // MARK: same state transitions
    let sameStateCombinations: [(SupermarketState, SupermarketEvent)] = [
      (.fillingInTheCart(initialShoppingCart), .givingMyCreditCard(creditCart)),
      (.fillingInTheCart(initialShoppingCart), .paymentHasSucceeded),
      (.fillingInTheCart(initialShoppingCart), .paymentHasFailed),
      (.atTheCheckout(initialShoppingCart), .walkingToCashier),
      (.atTheCheckout(initialShoppingCart), .itemWasAdded(item)),
      (.atTheCheckout(initialShoppingCart), .paymentHasSucceeded),
      (.atTheCheckout(initialShoppingCart), .paymentHasFailed),
      (.paying(updatedShoppingCart, creditCart, 3.5), .itemWasAdded(item)),
      (.paying(updatedShoppingCart, creditCart, 3.5), .walkingToCashier),
      (.goingHomeHappy(updatedShoppingCart), .itemWasAdded(item)),
      (.goingHomeHappy(updatedShoppingCart), .walkingToCashier),
      (.goingHomeHappy(updatedShoppingCart), .givingMyCreditCard(creditCart)),
      (.goingHomeHappy(updatedShoppingCart), .paymentHasSucceeded),
      (.goingHomeHappy(updatedShoppingCart), .paymentHasFailed),
      (.goingHomeSad(updatedShoppingCart), .itemWasAdded(item)),
      (.goingHomeSad(updatedShoppingCart), .walkingToCashier),
      (.goingHomeSad(updatedShoppingCart), .givingMyCreditCard(creditCart)),
      (.goingHomeSad(updatedShoppingCart), .paymentHasSucceeded),
      (.goingHomeSad(updatedShoppingCart), .paymentHasFailed),
    ]

    for combination in sameStateCombinations {
      await XCTAssert(
        systemUnderTest,
        when: combination.0,
        on: combination.1,
        transitionTo: .sameState
      )
    }
  }
}
