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

  enum FetchPriority {
    case high
    case low
  }

  enum FetchError: Error {
    case image
  }

  enum VideoPriority {
    case high
    case low
  }
}
