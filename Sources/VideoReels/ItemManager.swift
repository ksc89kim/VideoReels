//
//  ItemManager.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/22.
//

import Foundation

protocol ItemManager: AnyObject {

  //MARK: - Properties

  var items: [VideoReelsItem] { get set }
  var delegate: ItemManagerDelegate? { get set }

  //MARK: - Functions

  func reloadAll(items: [VideoReelsItem])
  func reload(items: [VideoReelsItem], isOverlap: Bool)
  func insert(items: [VideoReelsItem])
  func delete(idxs: Set<String>, isOverlap: Bool)
}


extension ItemManager {

  //MARK: - Properties

  var count: Int {
    self.items.count
  }

  //MARK: - Functions

  func setItem(at indexPath: IndexPath, item: VideoReelsItem) {
    guard self.items.count > indexPath.item, indexPath.item >= 0 else {
      return
    }
    self.items[indexPath.item] = item
  }

  func getItem(at indexPath: IndexPath) -> VideoReelsItem? {
    guard self.items.count > indexPath.item, indexPath.item >= 0 else {
      return nil
    }
    return self.items[indexPath.item]
  }

  func getItem(at page: Int) -> VideoReelsItem? {
    guard self.items.count > page, page >= 0 else {
      return nil
    }
    return self.items[page]
  }
}
