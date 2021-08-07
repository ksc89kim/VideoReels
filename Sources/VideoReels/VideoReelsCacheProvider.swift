//
//  VideoReelsCacheProvider.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/13.
//

import UIKit

public final class VideoReelsCacheProvider {

  // MARK: - Properties

  private var imageCaches: [String: UIImage] = [:]
  static let shared = VideoReelsCacheProvider()

  // MARK: - Functions

  public func saveImage(url: URL, image: UIImage) {
    self.imageCaches[url.absoluteString] = image
  }

  public func getImage(url: URL?) -> UIImage? {
    guard let url = url,
          self.imageCaches.keys.contains(url.absoluteString) else {
      return nil
    }

    return self.imageCaches[url.absoluteString]
  }

  // MARK: - Deinit

  deinit {
    print("deinit: VideoReelsCacheProvider")
  }
}
