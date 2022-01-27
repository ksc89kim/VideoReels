## VideoReels
---

## 릴스 UI 생성
```swift
private let reelsView: VideoReelsView = {
    let view = VideoReelsView.view()
    return view
}()
```

## 릴스 ReloadAll
---
```swift
self.reelsView.reloadAll(items: [
    VideoReelsBaseItem(
    idx: "\(idx)",
    url: URL(string: "비디오 URL"),
    isMuted: false
    )
])
```
-  전반적인 리로드를 진행합니다.

## 릴스 Reload
---
```swift
self.reelsView.reload(items: [
    VideoReelsBaseItem(
    idx: "\(idx)",
    url: URL(string: "비디오 URL"),
    isMuted: false
    )
])
```
- 부분적으로 리로드를 진행합니다.
- 기존 아이템 idx를 비교하여, 동영상을 교체합니다.
- 셀을 리로드하는 것이기에, 동영상이 멈추지 않기를 원한다면, Event를 사용해주세요.

## 릴스 Delete
--- 
```swift
var idxs = Set<String>()
idxs.insert("2")
self.reelsView.delete(idxs: idxs)
```
- idx에 해당하는 동영상을 삭제합니다.

## 릴스 Insert
---
```swift
 let items: [VideoReelsBaseItem] = [
    .init(
    idx: "11",
    url: URL(string: "비디오 URL"),
    isMuted: false
    ),
    .init(
    idx: "12",
    url: URL(string: "비디오 URL"),
    isMuted: false
    )
]
self.reelsView.insert(items: items)
```
- 동영상을 추가합니다.

## 릴스 Move
---
```swift
self.reelsView.moveToPage(3, animated: true)
```
- Index에 해당하는 동영상으로 이동합니다.

## 릴스 커스텀 하기
---
```swift

 self.reelsView.register(ReelsCell.self, itemType: ReelsItem.self)

struct ReelsItem: VideoReelsItem {
  var idx: String
  var url: URL?
  var isMuted: Bool
  var name: String
}

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
```
