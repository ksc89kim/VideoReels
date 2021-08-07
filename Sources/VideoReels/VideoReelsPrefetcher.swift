//
//  VideoReelsPrefetcher.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import Foundation

protocol VideoReelsPrefetcher: AnyObject {

  //MARK: - Defines

  typealias Response = VideoReels.FetchResponse
  typealias Priority = VideoReels.FetchPriority
  typealias FetchError = VideoReels.FetchError

  //MARK: - Properties

  var prefetchURLs: [URL] { get set }
  var pendingURLs: [URL] { get set }
  var pendingIndexs: [String: Int] { get set }
  var completedItems: [Response] { get set }
  var failedErrors: [Error] { get set }
  var isTasking: Bool { get set }
  var queue: DispatchQueue { get set }

  //MARK: - Function

  func load(url: URL, completion: @escaping (Response) -> Void)
}


extension VideoReelsPrefetcher {
  func start() {
    guard !self.isTasking else {
      return
    }

    self.isTasking = true
    self.queue.async { [weak self] in
      self?.next()
    }
  }

  func stop() {
    self.isTasking = false
  }

  func add(url: URL, priority: Priority) {
    switch priority {
    case .high:
      if self.pendingIndexs.keys.contains(url.absoluteString) {
        self.pendingURLs.bringToFront(item: url)
      } else {
        self.pendingURLs.insert(
          url,
          at: 0
        )
        self.prefetchURLs.append(url)
      }
    case .low:
      self.prefetchURLs.append(url)
      self.pendingURLs.append(url)
    }
    self.updatePendingIndexs()
  }

  func add(urls: [URL]) {
    self.prefetchURLs.append(contentsOf: urls)
    self.pendingURLs.append(contentsOf: urls)
    self.updatePendingIndexs()
  }
}


private extension VideoReelsPrefetcher {
  func next() {
    guard !self.finishedItems, self.isTasking else {
      self.reset()
      return
    }

    guard !self.pendingURLs.isEmpty else {
      return
    }

    let url = self.pendingURLs.removeFirst()
    self.pendingIndexs.removeValue(forKey: url.absoluteString)

    self.load(url: url){ [weak self] (response: Response) in
      switch response {
      case .success:
        self?.completedItems.append(response)
      case .fail(let error):
        self?.failedErrors.append(error)
      }

      self?.queue.async { [weak self] in
        self?.next()
      }
    }
  }

  func updatePendingIndexs() {
    self.pendingURLs.enumerated()
      .forEach { (offset: Int, url: URL) in
        self.pendingIndexs[url.absoluteString] = offset
      }
  }

  func reset() {
    self.isTasking = false
    self.pendingURLs.removeAll()
    self.completedItems.removeAll()
    self.prefetchURLs.removeAll()
    self.pendingIndexs.removeAll()
  }

  var finishedItems: Bool {
    let totalFinished = self.completedItems.count + self.failedErrors.count
    return totalFinished == self.prefetchURLs.count
  }
}
