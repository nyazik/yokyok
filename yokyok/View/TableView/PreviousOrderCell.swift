//
//  PreviousOrderCell.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import UIKit

class PreviousOrderCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var previoousOrderDateLabel: UILabel!
    
    @IBOutlet weak var addressTitleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var previousOrderPriceLabel: UILabel!
    
    func configureCell() {
        cellView.layer.cornerRadius = 10
        
    }
}
