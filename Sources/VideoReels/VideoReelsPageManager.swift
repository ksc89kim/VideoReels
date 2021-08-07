//
//  VideoReelsPageManager.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/15.
//

import Foundation

final class VideoReelsPageManager: PageManager {

  //MARK: - Properties

  var page: Int = 0
  var updatePage: ((Int) -> Void)?
}
