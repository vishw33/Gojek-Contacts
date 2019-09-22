//
//  DetailCell.swift
//  Gojek Contacts
//
//  Created by Vishwas on 22/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
