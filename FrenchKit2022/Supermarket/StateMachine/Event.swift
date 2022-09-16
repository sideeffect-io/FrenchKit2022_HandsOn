//
//  SupermarketEvent.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

enum SupermarketEvent: Equatable {
  case itemWasAdded(Item)
  case walkingToCashier
  case givingMyCreditCard(CreditCard)
  case paymentHasSucceeded
  case paymentHasFailed
  case reset
}
