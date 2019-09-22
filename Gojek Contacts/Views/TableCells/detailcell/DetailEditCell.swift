//
//  DetailEditCell.swift
//  Gojek Contacts
//
//  Created by Vishwas on 22/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class DetailEditCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailInfoTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
