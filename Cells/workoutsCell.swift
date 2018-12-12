//
//  workoutsCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/6/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
import ChameleonFramework
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
       //image.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "cellGradient") ).withAlphaComponent(0.8)
        image.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:CGRect(x: 0, y: 0, width: frame.width, height: frame.height-40), andColors:[#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)])
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
