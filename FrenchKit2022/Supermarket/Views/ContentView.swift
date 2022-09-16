//
//  ContentView.swift
//  FrenchKit2022
//
//  Created by Thibault Wittemberg on 16/09/2022.
//

import StateMachinePackage
import SwiftUI

struct ContentView: View {
  @ObservedObject
  var stateMachine: ViewStateMachine<SupermarketState, SupermarketEvent>

  var body: some View {
    NavigationView {
      VStack {
        // the state description
        Text(self.stateMachine.state.description)

        // the cashier
        self.cashier

        // the shopping cart in front of the cashier
        Group {
          if self.stateMachine.state.isAtTheCheckout {
            Image(systemName: self.stateMachine.state.hasItems ? "cart.badge.plus" : "cart")
              .resizable()
              .frame(width: 30, height: 30)
              .padding()
          } else {
            Color.clear
              .frame(width: 30, height: 30)
              .padding()
          }
        }
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: self.stateMachine.state)

        // the 4 shelves
        HStack {
          self.shelf1
          self.shelf2
          self.aisle
          self.shelf3
          self.shelf4
        }
        .padding()

        // the shopping cart down the aisle
        if !self.stateMachine.state.isAtTheCheckout {
          Image(systemName: self.stateMachine.state.hasItems ? "cart.badge.plus" : "cart")
            .resizable()
            .frame(width: 30, height: 30)
            .padding()
        } else {
          Color.clear
            .frame(width: 30, height: 30)
            .padding()
        }
      }
      .navigationTitle("The supermarket")
      .toolbar {
        Button("Reset") {
          self.stateMachine.send(.reset)
        }
      }
    }
    .task {
      await self.stateMachine.start()
    }
  }

  var cashier: some View {
    HStack {
      Button {
        // TODO: fire an event to give your credit card to the cashier

        // MARK: < PUT YOUR CODE HERE >
      } label: {
        Image(systemName: "dollarsign.square.fill")
          .resizable()
          .frame(width: 50, height: 50)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Rectangle().stroke())
    .padding()
  }

  var aisle: some View {
    VStack {
      HStack(alignment: .top) {
        Spacer()

        Button {
          // TODO: fire an event to walk to the cashier

          // MARK: < PUT YOUR CODE HERE >
        } label: {
          Image(systemName: "arrow.up")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 30)
            .padding()
        }
        Spacer()
      }
    }
  }

  var shelf1: some View {
    VStack {
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 99, name: "gamecontroller")))
      } label: {
        Image(systemName: "gamecontroller.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 60.50, name: "flowers")))
      } label: {
        Image(systemName: "camera.macro")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 560, name: "phone")))
      } label: {
        Image(systemName: "phone.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
    }.background(RoundedRectangle(cornerRadius: 5).stroke())
  }

  var shelf2: some View {
    VStack {
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 25, name: "trash")))
      } label: {
        Image(systemName: "trash.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 250.50, name: "books")))
      } label: {
        Image(systemName: "books.vertical.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 20.50, name: "umbrella")))
      } label: {
        Image(systemName: "umbrella.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
    }.background(RoundedRectangle(cornerRadius: 5).stroke())
  }

  var shelf3: some View {
    VStack {
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 40, name: "camera")))
      } label: {
        Image(systemName: "camera.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }

      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 10.25, name: "flashlight")))
      } label: {
        Image(systemName: "flashlight.on.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }

      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 2.65, name: "facemask")))
      } label: {
        Image(systemName: "facemask.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
    }.background(RoundedRectangle(cornerRadius: 5).stroke())
  }

  var shelf4: some View {
    VStack {
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 5.0, name: "scissors")))
      } label: {
        Image(systemName: "scissors")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 2699, name: "piano")))
      } label: {
        Image(systemName: "pianokeys.inverse")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
      Button {
        self.stateMachine.send(.itemWasAdded(Item(price: 34.50, name: "hammer")))
      } label: {
        Image(systemName: "hammer.fill")
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 30)
          .padding()
      }
    }.background(RoundedRectangle(cornerRadius: 5).stroke())
  }
}

struct ContentView_Previews: PreviewProvider {
  static func makePreviewViewStateMachine(initialState: SupermarketState) -> ViewStateMachine<SupermarketState, SupermarketEvent> {
    let updateStock = UpdateStock { _ in }
    let updateCustomerQueue = UpdateCustomerQueue { }
    let executeTransaction = ExecuteTransaction { _, _ in return true }
    let supermarketStateMachine = makeSupermarketStateMachine(
      initialState: initialState,
      updateStock: updateStock,
      updateCustomerQueue: updateCustomerQueue,
      executeTransaction: executeTransaction
    )

    return ViewStateMachine(stateMachine: supermarketStateMachine)
  }

  static let shoppingCart = ShoppingCart(
    id: UUID(),
    items: [
      Item(price: 4.3, name: "Pastas"),
      Item(price: 10.5, name: "Bananas")
    ])

  static let creditCart = CreditCard(number: "SD2345F54", pin: 1234)

  static var previews: some View {
    Group {
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .fillingInTheCart(.empty)))
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .fillingInTheCart(shoppingCart)))
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .atTheCheckout(shoppingCart)))
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .paying(shoppingCart, creditCart, 14.8)))
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .goingHomeHappy(shoppingCart)))
      ContentView(stateMachine: makePreviewViewStateMachine(initialState: .goingHomeSad(shoppingCart)))
    }
  }
}
