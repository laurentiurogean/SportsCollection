//
//  HeaderView.swift
//  SportsCollection
//
//  Created by Laurentiu Rogean.
//

import UIKit

class HeaderView: UICollectionReusableView {
  static let reuseIdentifier = "header-reuse-identifier"

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension HeaderView {
  func configure() {
    backgroundColor = .systemBackground

    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    let inset = CGFloat(10)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
    ])
    
    label.font = UIFont.preferredFont(forTextStyle: .title3)
  }
}
