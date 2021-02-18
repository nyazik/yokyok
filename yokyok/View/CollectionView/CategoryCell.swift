//
//  CategoryCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryQuantityLabel: UILabel!
    

    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        cellView.clipsToBounds = true
        
        gradientView.backgroundColor = UIColor.clear
        gradientView.applyGradient(colours: [.black, .clear])
    }
    
}
