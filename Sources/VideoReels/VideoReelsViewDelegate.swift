//
//  VideoReelsViewDelegate.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/08/02.
//

import UIKit

public protocol VideoReelsViewDelegate: AnyObject {
  func willDisyplay(cell: UICollectionViewCell, data: VideoReelsItem?, page: Int)
  func didEndDisplaying(cell: UICollectionViewCell, data: VideoReelsItem?, page: Int)
  func currentPage(_ page: Int, data: VideoReelsItem?)
}
