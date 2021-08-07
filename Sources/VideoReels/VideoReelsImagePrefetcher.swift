//
//  VideoReelsImagePrefetcher.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/13.
//

import UIKit
import AVFoundation

final class VideoReelsImagePrefetcher: VideoReelsPrefetcher {

  // MARK: - Properties
  
  var prefetchURLs: [URL] = []
  var pendingURLs: [URL] = []
  var pendingIndexs: [String : Int] = [:]
  var completedItems: [Response] = []
  var failedErrors: [Error] = []
  var isTasking: Bool = false
  var queue: DispatchQueue = .init(label: "video.reels.prefetch")
  private var asset: AVAsset?

  // MARK: - Functions

  func load(url: URL, completion: @escaping (Response) -> Void) {
    guard VideoReelsCacheProvider.shared.getImage(url: url) == nil else {
      completion(.fail(FetchError.image))
      return
    }

    self.asset = AVAsset(url: url)
    self.asset?.generateThumbnail { [weak self] (image: UIImage?) in
      self?.asset = nil
      if let image = image {
        VideoReelsCacheProvider.shared.saveImage(url: url, image: image)
        completion(.success)
        return
      }
      completion(.fail(FetchError.image))
    }
  }
}


private extension AVAsset {
  func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
    let imageGenerator = AVAssetImageGenerator(asset: self)
    let time = CMTime(seconds: 0.0, preferredTimescale: 600)
    let times = [NSValue(time: time)]
    imageGenerator.appliesPreferredTrackTransform = true
    imageGenerator.generateCGImagesAsynchronously(
      forTimes: times,
      completionHandler: { (_, image, _, _, _) in
        if let image = image {
          completion(UIImage(cgImage: image))
        } else {
          completion(nil)
        }
      }
    )
  }
}

