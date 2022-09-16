//
//  AsyncStream+Pipe.swift
//  
//
//  Created by Thibault Wittemberg on 18/09/2022.
//

extension AsyncStream {
  /// Create an input channel and an output sequence from an AsyncStream.
  /// It allows to bridge easily sync and async worlds
  /// - Returns: the input/output of an AsyncStream
  static func pipe() -> (AsyncStream.Continuation, AsyncStream) {
    var input: AsyncStream.Continuation!
    let output = AsyncStream(bufferingPolicy: .unbounded) { continuation in
      input = continuation
    }
    return (input, output)
  }
}
