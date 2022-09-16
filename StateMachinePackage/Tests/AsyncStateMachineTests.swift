//
//  AsyncStateMachineTests.swift
//  
//
//  Created by Thibault Wittemberg on 16/09/2022.
//

import StateMachinePackage
import XCTest

final class AsyncStateMachineTests: XCTestCase {
  enum State: Equatable {
    case idle
    case loading
    case loaded
    case failed
  }

  enum Event: Equatable {
    case loadingWasRequested
    case loadingWasSuccessful
    case loadingHasFailed
  }

  func makeStateMachine(load: SideEffect<Event>) -> StateMachine<State, Event> {
    StateMachine<State, Event>(initial: .idle) { state, event in
      switch (state, event) {
        case (.idle, .loadingWasRequested):
          return .newState(.loading, output: load)

        case (.loading, .loadingWasSuccessful):
          return .newState(.loaded)

        case (.loading, .loadingHasFailed):
          return .newState(.failed)

        default:
          return .sameState()
      }
    }
  }

  func test_asyncStateMachine_delivers_the_expected_states_and_execute_the_expected_outputs() {
    let idleStateReceived = expectation(description: "idle state received")
    let loadingStateReceived = expectation(description: "loading state received")
    let loadedStateReceived = expectation(description: "loaded state received")
    let sideEffectIsExecuted = expectation(description: "side effect is executed")

    let spySideEffect = SideEffect<Event> {
      sideEffectIsExecuted.fulfill()
      return nil
    }

    let stateMachine = self.makeStateMachine(load: spySideEffect)
    let systemUnderTest = AsyncStateMachine(stateMachine: stateMachine)

    Task {
      for await state in systemUnderTest {
        if state == .idle {
          idleStateReceived.fulfill()
        }

        if state == .loading {
          loadingStateReceived.fulfill()
        }

        if state == .loaded {
          loadedStateReceived.fulfill()
        }
      }
    }

    wait(for: [idleStateReceived], timeout: 2)

    systemUnderTest.send(.loadingWasRequested)

    wait(for: [loadingStateReceived], timeout: 2)

    systemUnderTest.send(.loadingWasSuccessful)

    wait(for: [loadedStateReceived], timeout: 2)

    wait(for: [sideEffectIsExecuted], timeout: 2)
  }
}
