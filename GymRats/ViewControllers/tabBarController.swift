//
//  tabBarController.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/15/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class tabBarController: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
       checkLogin()
       //logOutNow()
        
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        guard let items = tabBar.items else { return }
        for item in items
        {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -10, right: 0)
        }
    }
    
    func checkLogin()
    {
        if Auth.auth().currentUser?.uid == nil
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
            
        }
        
        
    }
    @objc func logOutNow()
    {
        do {
            try Auth.auth().signOut()
        }catch let loginErorr{
            print(loginErorr)
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc")
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
}
