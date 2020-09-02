//
//  Box.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 02/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import Foundation

final class Box<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  var value: T {
    didSet {
      listener?(value)
    }
  }
  init(_ value: T) {
    self.value = value
  }
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
