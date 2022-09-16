//
//  AsyncStateMachine.swift
//  
//
//  Created by Thibault Wittemberg on 18/09/2022.
//

/// An AsyncStateMachine is an AsyncSequence of states. Each event sent to the
/// AsyncStateMachine is stacked (thanks to an AsyncStream) , waiting to be used when the sequence is being iterated over.
/// `AsyncSequence` just like `Sequence` has to provide an `Iterator` that will provide all the consecutive values.
/// The `Iterator` must implement a `next()` function that will be called every time the consumer requests a new value.
public final class AsyncStateMachine<State, Event>: AsyncSequence, Sendable where State: Sendable, Event: Sendable {
  public typealias Element = State
  public typealias AsyncIterator = Iterator

  // the `AsyncStream` used to receive the user events
  let eventsInput: AsyncStream<Event>.Continuation
  // the same `AsyncStream` used to output the user events in the `next()` function
  let eventsStream: AsyncStream<Event>
  // the description of the state machine we want to run
  let stateMachine: StateMachine<State, Event>

  public init(stateMachine: StateMachine<State, Event>) {
    (self.eventsInput, self.eventsStream) = AsyncStream<Event>.pipe()
    self.stateMachine = stateMachine
  }

  var initialState: State {
    self.stateMachine.initial
  }

  /// stacks a new user event in the internal queue that will be unstacked when a new state is requested
  /// - Parameter event: the event to send into the state machine
  public func send(_ event: Event) {
    self.eventsInput.yield(event)
  }

  public func makeAsyncIterator() -> AsyncIterator {
    Iterator(
      eventsInput: self.eventsInput,
      eventsStream: self.eventsStream.makeAsyncIterator(),
      stateMachine: self.stateMachine
    )
  }

  public struct Iterator: AsyncIteratorProtocol {
    var currentState: State
    let eventsInput: AsyncStream<Event>.Continuation
    var eventsStream: AsyncStream<Event>.AsyncIterator
    let stateMachine: StateMachine<State, Event>
    let sideEffectExecutor = SideEffectExecutor<Event>()
    var initialStateHasBeenSent = false

    init(
      eventsInput: AsyncStream<Event>.Continuation,
      eventsStream: AsyncStream<Event>.AsyncIterator,
      stateMachine: StateMachine<State, Event>
    ) {
      self.currentState = stateMachine.initial
      self.eventsInput = eventsInput
      self.eventsStream = eventsStream
      self.stateMachine = stateMachine
    }

    // ///////////////////////////////////////
    // MARK: YOUR WORK BEGIN IN THIS FUNCTION!
    // ///////////////////////////////////////
    public mutating func next() async -> Element? {
      guard !Task.isCancelled else { return nil }

      // TODO: 1
      // return the initial state if this is the first call to `next()`
      // you can use the `self.initialStateHasBeenSent` property to help you make the decision, don't forget to update it :-)

      // MARK: < PUT YOUR CODE HERE >

      // as transitions might not produce a new state, we iterate over the input events
      // until we have a new state to deliver to the consumer.
    loop: while true {

      // TODO: 2
      // unstack the next event from the events AsyncStream. This can suspend until there is an event to process.
      // `self.eventsStream` is an iterator, you can call `next()` on it to retrieve the next event.
      // make sure we really have a non optional event, otherwise you can early return

      // MARK: < PUT YOUR CODE HERE >

      print("state machine: processing event \(event) ...")

      // TODO: 3
      // use the `self.stateMachine` property to compute the transition based on the current state and the event we've unstacked
      // this will give us a transition enum that contains:
      // - the next state (if any)
      // - the output (if any) to execute as a side effect

      // MARK: < PUT YOUR CODE HERE >

      // according to the value of the transition, we might set the new current state
      // and execute a side effect
      switch transition {
        case .sameState(.some(let sideEffect)):
          // TODO: 4
          // the state is the same, we won't deliver it to the consumer, no need to update the current state.
          // but there is a side effect to execute. Use the internal `self.sideEffectExecutor` to execute
          // the side effect in a Task. As the side effect might return an event, we must also provide
          // the `self.eventsInput` property tp the executor so the new event can be given back
          // and pushed in the events `AsyncStream`.

          // MARK: < PUT YOUR CODE HERE >

          continue loop

        case .sameState(.none):
          // state is the same, we won't deliver it, no need to update the current state
          // there is not side effect to execute ... nothing to do here
          continue loop

        case .newState(let state, .some(let sideEffect)):
          // TODO: 5
          // there is a new state, we will deliver it to the consumer, we have to update the current state

          // MARK: < PUT YOUR CODE HERE >

          // there is a side effect to execute, let's use `self.sideEffectExecutor` to execute it

          // MARK: < PUT YOUR CODE HERE >

          break loop

        case .newState(let state, .none):
          // TODO: 6
          // this is a new state, we will deliver it to the consumer, we have to update the current state
          // there is no side effect to execute

          // MARK: < PUT YOUR CODE HERE >

          break loop
      }
    }

      print("state machine: returning new state \(self.currentState) ...")

      // we deliver the new state to the consumer
      return self.currentState
    }
  }
}
