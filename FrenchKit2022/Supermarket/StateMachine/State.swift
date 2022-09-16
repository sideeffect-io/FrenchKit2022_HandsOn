//
//  SupermarketState.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

enum SupermarketState: Equatable {
  case fillingInTheCart(ShoppingCart)
  case atTheCheckout(ShoppingCart)
  case paying(ShoppingCart, CreditCard, Price)
  case goingHomeHappy(ShoppingCart)
  case goingHomeSad(ShoppingCart)
}

extension SupermarketState: CustomStringConvertible {
  var description: String {
    switch self {
      case .fillingInTheCart(let shoppingCart) where shoppingCart.items.isEmpty:
        return "Empty shopping cart"
      case .fillingInTheCart(let shoppingCart):
        return "Filling in the cart with \(shoppingCart.items.count) items"
      case .atTheCheckout(let shoppingCart):
        return "At the checkout \(shoppingCart.items.count) items"
      case .paying(_, _, let price):
        return "Paying \(price)$ ... waiting for the bank"
      case .goingHomeHappy:
        return "Going home happy 😄"
      case .goingHomeSad:
        return "Going home sad 😢"
    }
  }
}

extension SupermarketState {
  var shoppingCart: ShoppingCart {
    switch self {
      case .fillingInTheCart(let shoppingCart),
          .atTheCheckout(let shoppingCart),
          .paying(let shoppingCart, _, _),
          .goingHomeHappy(let shoppingCart),
          .goingHomeSad(let shoppingCart):
        return shoppingCart
    }
  }
}

extension SupermarketState {
  var hasItems: Bool {
    !self.shoppingCart.items.isEmpty
  }
}

extension SupermarketState {
  var isAtTheCheckout: Bool {
    switch self {
      case .atTheCheckout, .paying, .goingHomeHappy, .goingHomeSad:
        return true
      default:
        return false
    }
  }
}
