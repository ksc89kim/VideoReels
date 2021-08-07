//
//  PlayerControl.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/24.
//

import Foundation

protocol PlayerControl: AnyObject {

  //MARK: - Defines

  typealias Priority = VideoReels.VideoPriority
  
  //MARK: - Propreties

  var isPlay: Bool { get set }
  var delegate: PlayerControlDelegate? { get set }

  //MARK: - Functions

  func play(priority: Priority)
  func pause(priority: Priority)
  func toggle(priority: Priority, didSelect: Bool)
  func refresh()
}
