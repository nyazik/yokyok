//
//  SavedAddressesCell.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import UIKit

class SavedAddressesCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    func configureCell(){
        cellView.layer.cornerRadius = 10
        cellView.layer.backgroundColor = UIColor.white.cgColor
        
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
