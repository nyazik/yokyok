//
//  MyCartCell.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit

class MyCartCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var productCategoryLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productQuantityLabel: UILabel!
    
    
    func configureCell(){
        cellView.layer.cornerRadius = 10
//        cellView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
