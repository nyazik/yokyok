//
//  BannerCell.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit
import ShimmerSwift

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerShimmerView: ShimmeringView!
    
    func configureCell () {
        bannerImageView.layer.cornerRadius = 10
    }
}
