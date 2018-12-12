//
//  searchCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 12/5/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
    class searchCell: UITableViewCell {
        
        var name = UILabel()
        var uid = String()
        var img = UIImageView()
        
        override func layoutSubviews() {
            img.frame = CGRect(x: 0, y: 2, width: frame.height-4, height: frame.height-4)
            img.layer.cornerRadius = (frame.height-4) / 2
            img.layer.borderWidth = 3
            img.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            if(img.image != nil)
            {
                addSubview(img)
            }
            name.frame = CGRect(x: frame.height + 10, y: 0, width: frame.width-(frame.height + 10), height: frame.height)
            addSubview(name)
        }
}
