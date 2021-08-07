//
//  VideoReelsCollectionViewCell.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import UIKit

open class VideoReelsCollectionViewCell: UICollectionViewCell, MakeLayout, VideoReelsConfigure {

  // MARK: - UI Components

  private let playerView: VideoReelsPlayerView = {
    let playerView = VideoReelsPlayerView()
    return playerView
  }()

  // MARK: - Properties

  open var didMakeConstraints: Bool = false

  // MARK: - Initializers

  init() {
    defer {
      self.makeLayout()
    }
    super.init(frame: .zero)
  }

  public override init(frame: CGRect) {
    defer {
      self.makeLayout()
    }
    super.init(frame: frame)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycle

  open override func prepareForReuse() {
    super.prepareForReuse()
    self.playerView.reset()
  }

  // MARK: - Functions

  func setThumnailImage(image: UIImage) {
    self.playerView.thumnailImageView.image = image
  }

  // MARK: - Layout

  open func addSubViews() {
    self.addSubview(self.playerView)
  }

  open func makeConstraints() {
    self.playerView.translatesAutoresizingMaskIntoConstraints = false
    self.playerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    self.playerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    self.playerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    self.playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }

  // MARK: - Layout

  open func configure(item: VideoReelsItem) {
    self.playerView.configure(item: item)
  }

  open func configure(event: VideoReelsEvent) {
    self.playerView.configure(event: event)
  }
}
