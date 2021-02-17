//
//  MyAddressCell.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 1
        cellView.backgroundColor = .white
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
