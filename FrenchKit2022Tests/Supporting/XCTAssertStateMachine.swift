//
//  XCTAssertStateMachine.swift
//  FrenchKit2022Tests
//
//  Created by Thibault Wittemberg on 17/09/2022.
//

@testable import StateMachinePackage
import XCTest

enum TransitionTo<State>: Equatable where State: Equatable {
  case sameState
  case newState(State)
}

func XCTAssert<State, Event>(
  _ stateMachine: StateMachine<State, Event>,
  when state: State,
  on event: Event,
  transitionTo expectedTransition: TransitionTo<State>,
  sideEffectAssert: () async -> Bool = { true },
  file: StaticString = #filePath,
  line: UInt = #line
) async where State: Equatable {
  let receivedTransition = await stateMachine.transition(state, event)
  var receivedSideEffect: SideEffect<Event>?

  switch (expectedTransition, receivedTransition) {
    case (.sameState, .newState):
      XCTFail("Expected same state, got a new state")
    case (.newState(let expected), .sameState):
      XCTFail("Expected a new state \(expected), got the same state")
    case (.newState(let expectedState), .newState(let receivedState, let sideEffect)):
      receivedSideEffect = sideEffect
      XCTAssertEqual(expectedState, receivedState, file: file, line: line)
    case (.sameState, .sameState(output: let sideEffect)):
      receivedSideEffect = sideEffect
  }
  _ = await receivedSideEffect?.execute()
  let sideEffectAssertionResult = await sideEffectAssert()
  XCTAssertTrue(sideEffectAssertionResult, file: file, line: line)
}
