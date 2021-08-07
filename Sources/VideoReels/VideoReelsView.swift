//
//  VideoReelsView.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import UIKit

public final class VideoReelsView: UIView {

  // MARK: - UI Components

  private let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = UIScreen.main.bounds.size
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing = 0
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.bounces = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.scrollsToTop = false
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
    }
    collectionView.isPagingEnabled = true
    collectionView.register(
      VideoReelsCollectionViewCell.self,
      forCellWithReuseIdentifier: VideoReels.ReuseIdentifier.defualt.rawValue
    )
    return collectionView
  }()

  // MARK: - Properties

  var didMakeConstraints: Bool = false
  var isSelectPlayable: Bool = true
  weak var delegate: VideoReelsViewDelegate?
  private let manager: VideoReelsManager
  private let prefetcher: VideoReelsPrefetcher

  public var currentItem: VideoReelsItem? {
    return self.manager.itemManager.getItem(at: self.currentPage)
  }

  public var currentPage: Int {
    return self.manager.pageManager.page
  }

  private var currentIndexPath: IndexPath {
    return .init(item: self.currentPage, section: 0)
  }

  private var currentCell: VideoReelsCollectionViewCell? {
    return self.collectionView.cellForItem(at: self.currentIndexPath) as? VideoReelsCollectionViewCell
  }

  // MARK: - Initializers

  init(manager: VideoReelsManager, prefetcher: VideoReelsPrefetcher) {
    defer {
      self.makeLayout()
    }
    self.manager = manager
    self.prefetcher = prefetcher
    super.init(frame: .zero)
    self.manager.delegate = self
    self.collectionView.delegate = self
    self.collectionView.dataSource = self.manager
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public static func view() -> VideoReelsView {
    let itemManager = VideoReelsItemManager()
    let pageManager = VideoReelsPageManager()
    let playerControl = VideoReelsPlayerControl()
    let manager = VideoReelsCollectionManager(
      itemManager: itemManager,
      pageManager: pageManager,
      playerControl: playerControl
    )
    let prefetcher = VideoReelsImagePrefetcher()
    let view = VideoReelsView(manager: manager, prefetcher: prefetcher)
    return view
  }

  // MARK: - Functions

  public func register<T: VideoReelsCollectionViewCell>(_ ofType: T.Type, itemType: VideoReelsItem.Type) {
    self.collectionView.register(T.self, forCellWithReuseIdentifier: itemType.identifier)
    self.manager.register(identifier: itemType.identifier)
  }

  public func reloadAll(items: [VideoReelsItem]) {
    self.prefetch(items: items)
    self.manager.itemManager.reloadAll(items: items)
  }

  public func reload(items: [VideoReelsItem], isOverlap: Bool = false) {
    self.prefetch(items: items)
    self.manager.itemManager.reload(items: items, isOverlap: isOverlap)
  }

  public func insert(items: [VideoReelsItem]) {
    self.prefetch(items: items)
    self.manager.itemManager.insert(items: items)
  }

  public func delete(idxs: Set<String>, isOverlap: Bool = false) {
    self.manager.itemManager.delete(idxs: idxs, isOverlap: isOverlap)
  }

  private func prefetch(items: [VideoReelsItem]) {
    let urls = items.compactMap { $0.url }
    self.prefetcher.add(urls: urls)
  }

  public func send(event: VideoReelsEvent) {
    self.manager.send(event: event)
  }

  public func moveToPage(_ page: Int, animated: Bool) {
    self.collectionView.scrollToItem(at: .init(item: page, section: 0), at: .centeredVertically, animated: animated)
    guard !animated else {
      return
    }
    self.manager.pageManager.setPage(page)
  }
}


extension VideoReelsView: MakeLayout {
  public func addSubViews() {
    self.addSubview(self.collectionView)
  }

  public func makeConstraints() {
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
}


extension VideoReelsView: UICollectionViewDelegate {
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      self.manager.pageManager.setPage(offset: scrollView.contentOffset, size: scrollView.bounds.size)
    }
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.manager.pageManager.setPage(offset: scrollView.contentOffset, size: scrollView.bounds.size)
  }

  public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.manager.pageManager.setPage(offset: scrollView.contentOffset, size: scrollView.bounds.size)
  }

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    self.delegate?.willDisyplay(cell: cell, data: self.manager.itemManager.getItem(at: indexPath), page: indexPath.item)

    guard let url = self.manager.itemManager.getItem(at: indexPath)?.url,
          let cell = cell as? VideoReelsCollectionViewCell else {
      return
    }

    if let image = VideoReelsCacheProvider.shared.getImage(url: url) {
      cell.setThumnailImage(image: image)
    } else {
      self.prefetcher.add(url: url, priority: .high)
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    self.delegate?.didEndDisplaying(cell: cell, data: self.manager.itemManager.getItem(at: indexPath), page: indexPath.item)

    guard let reelsCell = cell as? VideoReelsCollectionViewCell else {
      return
    }

    reelsCell.configure(event: VideoReelsPauseEvent(priority: .low))
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard self.isSelectPlayable else {
      return
    }
    self.manager.playerControl.toggle(priority: .low, didSelect: true)
  }
}


extension VideoReelsView: VideoReelsManagerDelegate {
  func reloadAll() {
    self.collectionView.performBatchUpdates({
      self.collectionView.reloadData()
    },
    completion: { _ in
      self.manager.playerControl.refresh()
    })
  }

  func reload(indexPaths: [IndexPath]) {
    self.collectionView.reloadItems(at: indexPaths)
  }

  func insert(indexPaths: [IndexPath]) {
    self.collectionView.insertItems(at: indexPaths)
  }

  func delete(indexPaths: [IndexPath]) {
    self.collectionView.deleteItems(at: indexPaths)
  }

  func recive(event: VideoReelsEvent) {
    if event.shouldBatchUpdate {
      self.collectionView.performBatchUpdates(
        {},
        completion: { [weak self] _ in
          self?.currentCell?.configure(event: event)
        }
      )
    } else {
      self.currentCell?.configure(event: event)
    }
  }

  func currentPage(page: Int) {
    self.delegate?.currentPage(page, data: self.manager.itemManager.getItem(at: page))
  }
}
