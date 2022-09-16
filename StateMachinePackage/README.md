# StateMachinePackage

**Welcome again 😄!**

This package aims to provide the tools to run a state machine as an `AsyncSequence`.

Here is the public API of this package:

- `StateMachine`: a wrapper around an initial state, and transitions. `transitions` is a function with this signature: `(State, Event) async -> Transition`

- `Transition`: the result of a transition. It is an enum with 2 cases. The goal it to return the state (a new one or the same one) and an optional output to execute:
	- `.sameState(output:)`
	- `.newState(state:output:)`
	
- `SideEffect`: a wrapper around a side effect function that returns an optional `Event`. `SideEffects` will be returned in the `output:` field of a `Transition`

- `AsyncStateMachine`: an `AsyncSequence`, wrapping a `StateMachine` structure,  forwarding user inputs into the `StateMachine` and delivering a sequence a states over time

- `ViewStateMachine`: a wrapper around an `AsyncStateMachine` that can be used in a UI context. As it conforms to `ObservableObject`, a SwiftUI view can use it as an `@ObservedObject` variable

The basic structures like `StateMachine`, `Transition` or `SideEffect` are already implemented but the main engine `AsyncStateMachine` must be completed to wire everything up.

**If at any step of the exercice you are stuck, you can give a look at the fully functional implementation [here](https://github.com/sideeffect-io/FrenchKit2022/tree/main/StateMachinePackage).**

### Step 1

You can give a look at the `public/StateMachine.swift` file. There is nothing to complete here but it will help you understand the structure of a state machine.

### Step 2

Here's the heart of the state machine engine: the `AsyncStateMachine.swift` provides an `AsyncStateMachine`. It is an `AsyncSequence` wrapping a `StateMachine` structure. Its goal is to receive user events in an `AsyncStream` and use them inside the `next()` function to compute the next state and the outputs.

In `public/AsyncStateMachine.swift`:

`AsyncSequence` just like `Sequence` has to provide an `Iterator` that will provide all the successive state values. This `Iterator` must implement a `next()` function that will be called every time the consumer requests a new value.

```
eventsStream -> next event + current state -> new state + outputs
```

In this step we will finish the implementation of this `next()` function. You can follow the detailed comments in the file to fill in the gaps. The main things to do are:

- returning the initial state if this is the first call to `next()`
- unstacking the next user event from the internal `AsyncStream`
- executing the transition thanks to the state machine
- executing the side effect, if any
- returning the new state, if any

### Step 3

Now the package compiles, you can test your implementation of the `AsyncStateMachine` by running the test `AsyncStateMachineTests`. It should pass 🟢 before going any further.

### Step 4

We're almost done. 

In `public/ViewStateMachine.swift`, we have 2 things to do:

- forward the user events to the `AsyncStateMachine` in the `send(_:)` function
- iterate over the `AsyncSequence` to publish the states in a `Combine` publisher, so it can be listened to in a SwiftUI view

### Step 5

That is it for the Swift package. We now can:

- describe a state machine thanks to `StateMachine`, `Transition` and `SideEffect`
- run that state machine as an `AsyncSequence` with `AsyncStateMachine`
- execute that state machine in the context of a SwiftUI view with `ViewStateMachine`

### Step 6

Go back to the main [README](../README.md) to complete the steps for the main application.