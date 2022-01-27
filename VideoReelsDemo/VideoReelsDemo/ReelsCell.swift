//
//  ReelsCell.swift
//  VideoReelsDemo
//
//  Created by kim sunchul on 2021/08/07.
//

import UIKit
import VideoReels

final class ReelsCell: VideoReelsCollectionViewCell {

  // MARK: - UI Components

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    return label
  }()


  // MARK: - Override

  override func addSubViews() {
    super.addSubViews()

    self.contentView.addSubview(self.nameLabel)
  }

  override func makeConstraints() {
    super.makeConstraints()

    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
    self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
    self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
  }

  override func configure(event: VideoReelsEvent) {
    super.configure(event: event)
    print("## event \(event)")
  }

  override func configure(item: VideoReelsItem) {
    super.configure(item: item)
    print("## item \(item)")

    if let reelsItem = item as? ReelsItem {
      self.nameLabel.text = reelsItem.name
    }
  }
}
