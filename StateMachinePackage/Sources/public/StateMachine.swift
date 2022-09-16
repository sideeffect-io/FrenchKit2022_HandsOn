//
//  StateMachine.swift
//  
//
//  Created by Thibault Wittemberg on 16/09/2022.
//

/// Wrapper around a side effect function.
/// A side effect return eventually an event. It can return nil in case of a fire-and-forget side effect.
/// We could augment this Wrapper with some meta information like the TaskPriority when want to apply
/// or a cancellation policy.
public struct SideEffect<Event>: Sendable {
  let execute: @Sendable () async -> Event?

  public init(execute: @Sendable @escaping () async -> Event?) {
    self.execute = execute
  }
}

/// The result of a transition involving a current state and an event
public enum Transition<State, Event> {
  /// the transition does not create a new state but can eventually perform a side effect
  case sameState(output: SideEffect<Event>? = nil)
  /// the transitions creates a new state and can eventually perform a side effect
  case newState(State, output: SideEffect<Event>? = nil)
}

/// A StateMachine is a wrapper around an initial state and a function that returns all the possible transitions.
///
/// Example:
///
/// ```
/// func makeStateMachine(load: (String) -> SideEffect<Event>) -> StateMachine<State, Event> {
///   StateMachine(initial: .idle) { state, event in
///     switch (state, event) {
///     case (.idle, .loadIsRequested(let id)):
///       return .newState(state: .loading, output: load(id: id))
///
///     case (.loading, .loadHasSucceeded(let data)):
///       return .newState(.loaded(data: data))
///
///     case (.loading, .loadHasFailed):
///       return .newState(.failed)
///   }
/// }
/// ```
public struct StateMachine<State, Event>: Sendable where State: Sendable {
  let initial: State
  let transition: @Sendable (State, Event) async -> Transition<State, Event>

  public init(initial: State, transition: @Sendable @escaping (State, Event) async -> Transition<State, Event>) {
    self.initial = initial
    self.transition = transition
  }
}
