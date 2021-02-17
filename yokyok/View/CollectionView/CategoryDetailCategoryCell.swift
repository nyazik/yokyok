//
//  CategoryDetailCategoryCell.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class CategoryDetailCategoryCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.backgroundColor = UIColor.white
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    func reload() {
        if isSelected {
            cellView.backgroundColor  = UIColor.systemPink
            cellView.layer.borderColor = UIColor.systemPink.cgColor

        }
        
        else {
            cellView.backgroundColor  = UIColor.white
            cellView.layer.borderColor = UIColor.lightGray.cgColor

        }
    }
    
    
}
