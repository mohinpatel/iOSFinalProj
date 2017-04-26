//
//  MapCell.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/19/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTapped: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
