//
//  ViewStateMachine.swift
//  
//
//  Created by Thibault Wittemberg on 18/09/2022.
//

import SwiftUI

/// Consumes an AsyncStateMachine and publishes the state as a Combine publisher so the View can be refreshed
public class ViewStateMachine<State, Event>: ObservableObject where State: Sendable, Event: Sendable {
  @Published
  public private(set) var state: State

  private let asyncStateMachine: AsyncStateMachine<State, Event>

  public init(stateMachine: StateMachine<State, Event>) {
    self.state = stateMachine.initial
    self.asyncStateMachine = AsyncStateMachine(
      stateMachine: stateMachine
    )
  }

  @MainActor
  func publish(_ state: State) {
    self.state = state
  }

  public func send(_ event: Event) {
    // TODO: 1
    // simply forward the event to the async state machine

    // MARK: < PUT YOUR CODE HERE >
  }

  public func start() async {
    // TODO: 2
    // iterate over the async state machine and publish the new state thanks to the `publish(_:)` function

    // MARK: < PUT YOUR CODE HERE >
  }
}

