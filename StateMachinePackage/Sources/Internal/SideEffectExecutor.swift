//
//  SideEffectExecutor.swift
//  
//
//  Created by Thibault Wittemberg on 18/09/2022.
//


/// We use an actor so the Task execution inherits from this Actor executor.
actor SideEffectExecutor<Event> {
  init() {}

  /// Executes the submitted side effects in the context of a Task. We could capture the task in an array of we want to be able to cancel all the pending tasks
  /// - Parameters:
  ///   - sideEffect: the side effect to execute
  ///   - eventInput: the event input channel to submit the resulting event back to the async state machine
  func execute(
    sideEffect: SideEffect<Event>,
    eventInput: AsyncStream<Event>.Continuation
  ) {
    Task {
      guard let event = await sideEffect.execute() else {
        return
      }
      eventInput.yield(event)
    }
  }
}
