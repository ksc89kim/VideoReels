//
//  MakeLayout.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import Foundation

protocol MakeLayout: AnyObject {

  //MARK: - Properties

  var didMakeConstraints: Bool { get set }

  //MARK: - Functions

  func addSubViews()
  func makeConstraints()
}


extension MakeLayout {
  func makeLayout() {
    self.addSubViews()
    self.makeConstraintsIfNeeded()
  }

  func makeConstraintsIfNeeded() {
    if !self.didMakeConstraints {
      self.makeConstraints()
      self.didMakeConstraints = true
    }
  }
}

