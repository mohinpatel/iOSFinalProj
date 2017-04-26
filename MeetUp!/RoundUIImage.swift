//
//  RoundUIImage.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/6/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit

class RoundUIImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
        override func awakeFromNib() {
            
        }
        
        
        func setImageAndShadow(image: UIImage) {
            self.image = image
            self.superview?.layoutIfNeeded()
            print("Image size \(self.frame.size)")
            self.clipsToBounds = true
            layer.masksToBounds = true
            layer.cornerRadius = self.frame.height / 2
            layer.shadowOffset = CGSize(width: 0, height: 3.0)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.7
            layer.shadowRadius = 4
            
        }
        
    }


