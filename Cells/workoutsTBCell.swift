//
//  workoutsTBCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/11/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

//
//  workoutsCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/6/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
class workoutsTBCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var completeImage: UIImageView!
    var complete: Bool!
    
    override func layoutSubviews() {
        
        theImage.frame = CGRect(x: 5, y: 5, width: frame.width * 0.3, height: frame.height-10)
        theImage.contentMode = .scaleAspectFit
        name.frame = CGRect(x: frame.width * 0.3 + 20, y: frame.height/2-20, width: frame.width/2, height: 40)
        completeImage.frame = CGRect(x: frame.width-60, y: frame.height/2-25, width: 50, height: 50)
        
    }
}
