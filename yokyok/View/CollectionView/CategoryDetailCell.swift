//
//  CategoryDetailCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class CategoryDetailCell: UICollectionViewCell {
    @IBOutlet weak var productView: UIView!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productCategoryLabel: UILabel!
    
    
    func configureCell() {
        productView.backgroundColor = UIColor.white
        productView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        productView.layer.cornerRadius = 10

    }
}
