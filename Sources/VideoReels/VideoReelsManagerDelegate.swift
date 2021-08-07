//
//  VideoReelsManagerDelegate.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/25.
//

import Foundation

protocol VideoReelsManagerDelegate: ItemManagerDelegate {
  func recive(event: VideoReelsEvent)
  func currentPage(page: Int)
}
