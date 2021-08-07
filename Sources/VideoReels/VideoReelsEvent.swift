//
//  VideoReelsEvent.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/24.
//

import Foundation

public protocol VideoReelsEvent {
  var shouldBatchUpdate: Bool { get set }
}

struct VideoReelsPlayEvent: VideoReelsEvent {
  public var shouldBatchUpdate: Bool = true
  let priority: VideoReels.VideoPriority
  var didSelect: Bool = false
}

struct VideoReelsPauseEvent: VideoReelsEvent {
  public var shouldBatchUpdate: Bool = false
  let priority: VideoReels.VideoPriority
  var didSelect: Bool = false
}
