//
//  CircularCollectionViewCell.swift
//  SportsCollection
//
//  Created by Laurentiu Rogean.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifer = "CircularCollectionViewCell"
    
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportTitleLabel: UILabel!
    var sportItem: SportItem?
    
    func configure(with item: SportItem) {
        self.sportItem = item
        
        sportImageView.image = UIImage(named: item.image)
        sportTitleLabel.text = item.name
    }
}
