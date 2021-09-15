//
//  RectangularCollectionViewCell.swift
//  SportsCollection
//
//  Created by Laurentiu Rogean.
//

import UIKit

class RectangularCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifer = "RectangularCollectionViewCell"
    
    @IBOutlet weak var sportImageView: UIImageView!
    var sportItem: SportItem?
    
    func configure(with item: SportItem) {
        self.sportItem = item
        
        sportImageView.image = UIImage(named: item.image)
    }

}
