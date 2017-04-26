//
//  RoundedButton.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/6/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 20.0
//        clipsToBounds = true
//        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        setTitleColor(tintColor, forState: .Normal)
//        setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
//        setBackgroundImage(UIImage(color: tintColor), forState: .Highlighted)
    }

}
