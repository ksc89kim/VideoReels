//
//  VideoReels+Defines.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import Foundation

public struct VideoReels {
  public enum ReuseIdentifier: String {
    case defualt = "VideoReelsBase"
  }

  enum FetchResponse {
    case success
    case fail(VideoReels.FetchError)
  }

  enum FetchPriority: Int {
    case low = 1
    case high = 10000
  }

  enum FetchError: Error {
    case image
  }

  enum VideoPriority {
    case high
    case low
  }

  struct PendingItem: Comparable {
    let url: URL
    let priority: Int

    static func < (lhs: PendingItem, rhs: PendingItem) -> Bool {
      return lhs.priority < rhs.priority
    }
  }
}
