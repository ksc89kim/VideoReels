//
//  ItemManagerDelegate.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/24.
//

import Foundation

protocol ItemManagerDelegate: AnyObject {
  func reloadAll()
  func reload(indexPaths: [IndexPath])
  func insert(indexPaths: [IndexPath])
  func delete(indexPaths: [IndexPath])
}
