//
//  FavouriteProductCellTableViewCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class FavouriteProductCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    
    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.backgroundColor = UIColor.white
//        cellView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
    }
    
}
