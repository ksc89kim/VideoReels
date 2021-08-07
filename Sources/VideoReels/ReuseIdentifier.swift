//
//  ReuseIdentifier.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/08/02.
//

import Foundation

public protocol ReuseIdentifier {
  static var identifier: String { get }
  var identifier: String { get }
}


extension ReuseIdentifier {
  public var identifier: String {
    return String(describing: Self.self)
  }

  public static var identifier: String {
    return String(describing: self)
  }
}
