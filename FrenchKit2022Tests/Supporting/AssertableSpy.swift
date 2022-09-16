//
//  Spy.swift
//  FrenchKit2022Tests
//
//  Created by Thibault Wittemberg on 20/09/2022.
//

import XCTest

actor Spy<Value> where Value: Equatable {
  var value: Value

  init(value: Value) {
    self.value = value
  }

  func set(value: Value) {
    self.value = value
  }
}
