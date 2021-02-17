//
//  PreviousOrderDetailCell.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import UIKit

class PreviousOrderDetailCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
 
    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.layer.backgroundColor = UIColor.white.cgColor
    }
}
