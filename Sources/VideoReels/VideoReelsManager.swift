//
//  VideoReelsManager.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/13.
//

import UIKit

protocol VideoReelsManager where Self: UICollectionViewDataSource {
  var itemManager: ItemManager { get set }
  var pageManager: PageManager { get set }
  var playerControl: PlayerControl { get set }
  var delegate: VideoReelsManagerDelegate? { get set }

  func register(identifier: String)
  func send(event: VideoReelsEvent)
}

extension VideoReelsManager {
  typealias ReuseIdentifier = VideoReels.ReuseIdentifier
}
