//
//  PlayerControlDelegate.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/28.
//

import Foundation

protocol PlayerControlDelegate: AnyObject {
  func play(priority: VideoReels.VideoPriority, didSelect: Bool)
  func pause(priority: VideoReels.VideoPriority, didSelect: Bool)
}
