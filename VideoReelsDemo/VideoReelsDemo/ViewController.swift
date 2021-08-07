//
//  ViewController.swift
//  VideoReels
//
//  Created by kim sunchul on 2021/07/04.
//

import UIKit
import VideoReels

final class ViewController: UIViewController {

  // MARK: - UI Components

  private let reelsView: VideoReelsView = {
    let view = VideoReelsView.view()
    return view
  }()

  private let contentView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()

  private let deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("Delete", for: .normal)
    return button
  }()

  private let moveButton: UIButton = {
    let button = UIButton()
    button.setTitle("Move", for: .normal)
    return button
  }()

  private let insertButton: UIButton = {
    let button = UIButton()
    button.setTitle("Insert", for: .normal)
    return button
  }()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()

    let items = [
      "IMG_0829",
      "IMG_0829",
      "IMG_0829",
      "IMG_0829"
    ]
    .enumerated()
    .map { idx, url -> VideoReelsBaseItem in
      return .init(idx: "\(idx)", url: self.createLocalUrl(for: url, ofType: "mov"), isMuted: false)
    }
    self.reelsView.reloadAll(items: items)
  }

  // MARK: - Setup

  private func setup() {
    self.view.addSubview(self.reelsView)
    self.view.addSubview(self.contentView)
    self.contentView.addArrangedSubview(self.deleteButton)
    self.contentView.addArrangedSubview(self.moveButton)
    self.contentView.addArrangedSubview(self.insertButton)

    self.reelsView.translatesAutoresizingMaskIntoConstraints = false
    self.reelsView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    self.reelsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    self.reelsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    self.reelsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true

    self.deleteButton.addAction(
      .init(handler: { _ in
        var idxs = Set<String>()
        idxs.insert("2")
        self.reelsView.delete(idxs: idxs)
      }),
      for: .touchUpInside
    )

    self.moveButton.addAction(
      .init(handler: { _ in
        self.reelsView.moveToPage(3, animated: true)
      }),
      for: .touchUpInside
    )

    self.insertButton.addAction(
      .init(handler: { _ in
        let items: [VideoReelsBaseItem] = [
          .init(
            idx: "11",
            url: self.createLocalUrl(for: "IMG_0829", ofType: "mov"),
            isMuted: false
          ),
          .init(
            idx: "12",
            url: self.createLocalUrl(for: "IMG_0829", ofType: "mov"),
            isMuted: false
          )
        ]
        self.reelsView.insert(items: items)
      }),
      for: .touchUpInside
    )
  }

  // MARK: - Functions

  private func createLocalUrl(for filename: String, ofType: String) -> URL? {
    let fileManager = FileManager.default
    let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let url = cacheDirectory.appendingPathComponent("\(filename).\(ofType)")
    guard fileManager.fileExists(atPath: url.path) else {
      guard let video = NSDataAsset(name: filename)  else { return nil }
      fileManager.createFile(atPath: url.path, contents: video.data, attributes: nil)
      return url
    }
    return url
  }
}

