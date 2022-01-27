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
  typealias PendingItem = VideoReels.PendingItem

  //MARK: - Properties

  var prefetchURLs: [URL] { get set }
  var pendingQueue: PriorityQueue<PendingItem> { get set }
  var priorityCount: Int { get set }
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

  func add(urls: [URL]) {
    urls.forEach { (url: URL) in
      self.add(url: url, priority: .low)
    }
  }

  func add(url: URL, priority: Priority) {
    self.clearMaxPriorityIfNeeded()
    self.pendingQueue.insert(.init(url: url, priority: self.priorityCount * priority.rawValue))
    self.prefetchURLs.append(url)
    self.addPriorityCount()
  }
}


private extension VideoReelsPrefetcher {
  func next() {
    guard !self.finishedItems, self.isTasking else {
      self.reset()
      return
    }

    guard let url = self.pendingQueue.pop()?.url else {
      return
    }

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

  func reset() {
    self.isTasking = false
    self.completedItems.removeAll()
    self.pendingQueue.removeAll()
    self.prefetchURLs.removeAll()
    self.clearMaxPriorityIfNeeded()
  }

  func addPriorityCount() {
    self.priorityCount += 1
  }

  func clearMaxPriorityIfNeeded() {
    guard self.pendingQueue.isEmpty else { return }
    self.priorityCount = 1
  }

  var finishedItems: Bool {
    let totalFinished = self.completedItems.count + self.failedErrors.count
    return totalFinished == self.prefetchURLs.count
  }
}
