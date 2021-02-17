//
//  BannerCell.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    
    func configureCell () {
        bannerImageView.layer.cornerRadius = 10
    }
}
