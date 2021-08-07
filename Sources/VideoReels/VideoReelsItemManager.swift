//
//  VideoReelsItemManager.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/13.
//

import Foundation

final class VideoReelsItemManager {

  //MARK: - Properties

  var items: [VideoReelsItem] = []
  weak var delegate: ItemManagerDelegate?

  // MARK: - Initializers

  init() {
  }
}


extension VideoReelsItemManager: ItemManager {
  func reloadAll(items: [VideoReelsItem]) {
    self.items = items
    self.delegate?.reloadAll()
  }

  func reload(items: [VideoReelsItem], isOverlap: Bool) {
    guard !self.items.isEmpty else {
      assertionFailure("Item Empty")
      return
    }

    var indexPaths: [IndexPath] = []
    var reloadItems = items
    let updateItems = self.items.enumerated().map { originalIndex, originalItem -> VideoReelsItem in
      if let reload = reloadItems.enumerated().first(where: { $0.element.idx == originalItem.idx }) {
        if isOverlap {
          reloadItems.remove(at: reload.offset)
        }
        indexPaths.append(.init(item: originalIndex, section: 0))
        return reload.element
      }
      return originalItem
    }
    self.items = updateItems
    self.delegate?.reload(indexPaths: indexPaths)
  }

  func insert(items: [VideoReelsItem]) {
    let startIndex = self.items.count
    let endIndex = self.items.count + items.count
    let indexPaths = (startIndex ..< endIndex).map { index -> IndexPath in
      return .init(item: index, section: 0)

    }
    self.items.append(contentsOf: items)
    self.delegate?.insert(indexPaths: indexPaths)
  }

  func delete(idxs: Set<String>, isOverlap: Bool) {
    var indexPaths: [IndexPath] = []
    var deleteItems = items
    let updateItems = self.items.enumerated().compactMap { index, originalItem -> VideoReelsItem? in
      if let delete = idxs.enumerated().first(where: { $0.element == originalItem.idx }) {
        if isOverlap {
          deleteItems.remove(at: delete.offset)
        }
        indexPaths.append(.init(item: index, section: 0))
        return nil
      }
      return originalItem
    }

    self.items = updateItems
    self.delegate?.delete(indexPaths: indexPaths)
  }
}
