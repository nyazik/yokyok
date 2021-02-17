//
//  PopularProductCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class PopularProductCell: UICollectionViewCell {
    
    @IBOutlet weak var popularProductView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    
    func configureCell() {
        popularProductView.backgroundColor = UIColor.white
        popularProductView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        popularProductView.layer.cornerRadius = 10
    }
}
