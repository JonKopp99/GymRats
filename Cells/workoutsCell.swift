//
//  workoutsCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/6/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
class workoutsCell: UICollectionViewCell {
    @IBOutlet var nanme: UILabel!
    @IBOutlet var image: UIImageView!
    override func layoutSubviews() {
        
        image.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-40)
        nanme.frame = CGRect(x: 0, y: frame.height-40, width: frame.width, height: 40)
        image.contentMode = .scaleAspectFit
        let rect = UIView(frame: CGRect(x: 0, y: 0, width: image.frame.width, height: image.frame.height))
       rect.backgroundColor = .clear
       rect.layer.borderWidth = 2
       rect.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
       image.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).withAlphaComponent(0.8)
       image.layer.cornerRadius = 20
       image.clipsToBounds = true
       rect.layer.cornerRadius = 20
       image.addSubview(rect)
        
        //nanme.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        //nanme.font = UIFont(name: "AvenirNext-Bold", size: 25)
        //nanme.textAlignment = .center
        //nanme.adjustsFontSizeToFitWidth = true
        //nanme.sizeToFit()
        
        
        
        
        
    }
}
