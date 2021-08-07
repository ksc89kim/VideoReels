//
//  VideoReelsItem.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/24.
//

import UIKit

public protocol VideoReelsItem: ReuseIdentifier {
  var idx: String { get set }
  var url: URL? { get set }
  var isMuted: Bool { get set }
}


public struct VideoReelsBaseItem: VideoReelsItem {
  public var idx: String
  public var url: URL?
  public var isMuted: Bool

  public init(idx: String, url: URL?, isMuted: Bool) {
    self.idx = idx
    self.url = url
    self.isMuted = isMuted
  }
}
