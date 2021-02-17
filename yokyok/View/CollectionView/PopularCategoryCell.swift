//
//  PopularCategoryCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class PopularCategoryCell: UICollectionViewCell {
    @IBOutlet weak var popularProductView: UIView!
    @IBOutlet weak var popularCategoryImageView: UIImageView!
    @IBOutlet weak var popularCategoryProductNameLabel: UILabel!
    @IBOutlet weak var popularCategoryProductQuantityLabel: UILabel!
    
    func configureCell() {
        popularProductView.backgroundColor = UIColor.white
        popularProductView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        popularProductView.layer.cornerRadius = 10
        popularProductView.clipsToBounds = true
    }
}
