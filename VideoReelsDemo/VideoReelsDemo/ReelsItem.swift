//
//  ReelsItem.swift
//  VideoReelsDemo
//
//  Created by kim sunchul on 2021/08/07.
//

import Foundation
import VideoReels

struct ReelsItem: VideoReelsItem {
  var idx: String
  var url: URL?
  var isMuted: Bool
  var name: String
}
