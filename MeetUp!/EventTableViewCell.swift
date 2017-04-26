//
//  EventTableViewCell.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/18/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var friends: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
