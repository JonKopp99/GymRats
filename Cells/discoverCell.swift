//
//  discoverCell.swift
//  GymRats
//
//  Created by Jonathan Kopp on 12/2/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit



class discoverCell: UICollectionViewCell
{
    
    var username = UILabel()
    var theImage = UIImageView()
    var theName = UILabel()
    var theDesc = UITextView()
    var likes = UILabel()
    var tabBarHeight = CGFloat()
    override func layoutSubviews() {
        
        
        
        username.frame = CGRect(x: 10, y: 0, width: frame.width-20, height: 40)
        
        theName.frame = CGRect(x: 10, y: 0, width: frame.width-20, height: 50)
        
        
        let userView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
        userView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        userView.addSubview(username)
        
        print("tabBarHeight: \(tabBarHeight)")
        
        let theHeight =  frame.height - (frame.height * 0.6 + tabBarHeight)
        
        let infoView = UIView(frame: CGRect(x: 0, y: frame.height * 0.6, width: frame.width, height: theHeight))
        infoView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        infoView.addSubview(theName)
        
        theDesc.frame = CGRect(x: 10, y: theName.frame.maxY, width: frame.width-20, height: 150)
        infoView.addSubview(theDesc)
        theImage.frame = CGRect(x: 0, y: 40, width: frame.width, height: infoView.frame.minY)
        
        
        theImage.contentMode = .scaleAspectFit
        theImage.clipsToBounds = true
        
        
        
        addSubview(theImage)
        addSubview(userView)
        addSubview(infoView)
        
    }
    
    
}
