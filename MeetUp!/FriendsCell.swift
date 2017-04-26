//
//  FriendsCell.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/18/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {


    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addedFriend: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
