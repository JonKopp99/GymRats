//
//  ProfileViewController.swift
//  GymRats
//
//  Created by Jonathan Kopp on 12/7/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UINavigationControllerDelegate{

    
    var workouts = [workout]()
    var dispatchGroup = DispatchGroup()
    var currentView = UIView()
    var currentRow = Int()
    var usernameLabel = UILabel()
    var profImg = UIImageView()
    var tabBarHeight = CGFloat()
    var moreView = UIView()
    var imgView = UIImageView()
    var theName = UILabel()
    var theDesc = UITextView()
    var navView = UIView()
    var swipeImg = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        currentRow = 0
        navView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.3))
        navView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.6117647059, blue: 1, alpha: 1)
        navView.isOpaque = true
        getProfileInfo()
        
        
        let profImgSize = (navView.bounds.height * 0.6)
        profImg.frame = CGRect(x: navView.bounds.width / 2 - (profImgSize / 2), y: navView.bounds.height * 0.2, width: profImgSize, height: profImgSize)
        profImg.layer.cornerRadius = profImgSize / 2
        profImg.layer.borderWidth = 3
        profImg.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        profImg.contentMode = .scaleAspectFill
        profImg.clipsToBounds = true
        navView.addSubview(profImg)
        
        usernameLabel = UILabel(frame: CGRect(x:0, y: navView.bounds.height - 50, width: navView.bounds.width, height: 50))
        usernameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        usernameLabel.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 35.0)
        usernameLabel.textAlignment = .center
        usernameLabel.adjustsFontSizeToFitWidth = true
        
        let logOutButton = UIButton(frame: CGRect(x: navView.bounds.width - 40, y: navView.bounds.height * 0.2, width: 35, height: 35))
        logOutButton.backgroundColor = .clear
        logOutButton.setImage(#imageLiteral(resourceName: "icons8-login-filled-50"), for: .normal)
        logOutButton.addTarget(self, action:#selector(self.logOutNow), for: .touchUpInside)
        
        navView.addSubview(logOutButton)
        navView.addSubview(usernameLabel)
        view.addSubview(navView)
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
        swipeUP.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUP)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        loadCells()
        dispatchGroup.notify(queue: .main) {
            
            self.createView()
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func createView()
    {
        moreView = UIView()
       if(workouts.count<=0){
           return
       }
        tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        
        tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        let theight = (self.view.bounds.height - self.navView.bounds.height) - (tabBarHeight)
        currentView.frame = CGRect(x: 0, y: navView.frame.maxY, width: self.view.bounds.width, height: theight)
        
        
        imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: currentView.bounds.width, height: currentView.bounds.height)
        if(workouts[currentRow].image.image == nil)
        {
            imgView.downloadImage(from: workouts[currentRow].imagePath)
            workouts[currentRow].image.image = imgView.image
        }else{
            imgView.image = workouts[currentRow].image.image
        }
        
        imgView.contentMode = .scaleToFill
        currentView.addSubview(imgView)
        
        moreView.frame = CGRect(x: 0, y: currentView.frame.maxY, width: currentView.bounds.width, height: currentView.bounds.height * 0.3)
        self.moreView.backgroundColor = .clear
        theName = UILabel()
        theName.frame = CGRect(x: 5, y: 0, width: moreView.bounds.width - 10, height: 40)
        theName.text = workouts[currentRow].name
        theName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theName.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 25)
        theName.textAlignment = .left
        theName.adjustsFontSizeToFitWidth = true
        
        theDesc = UITextView()
        theDesc.frame = CGRect(x: 0, y: theName.frame.maxY + 5, width: moreView.bounds.width - 5, height: (moreView.bounds.height - 50))
        theDesc.text = workouts[currentRow].description
        theDesc.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theDesc.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 25)
        theDesc.isEditable = false
        theDesc.backgroundColor = .clear
        theDesc.textAlignment = .left
        
        let right = UIImageView(frame: CGRect(x: currentView.bounds.width - 40, y: (imgView.bounds.height / 2) + 40, width: 40, height: 40))
        right.image = #imageLiteral(resourceName: "icons8-rightcopy")
        right.alpha = 0.7
        let left = UIImageView(frame: CGRect(x: 0, y: (imgView.bounds.height / 2) + 40, width: 40, height: 40))
        left.image = #imageLiteral(resourceName: "icons8left")
        left.alpha = 0.7
        
        moreView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.6117647059, blue: 1, alpha: 1)
        
        self.view.addSubview(currentView)
        swipeImg.frame = CGRect(x: self.view.bounds.width / 2 - 20, y: self.currentView.frame.maxY - 40, width: 40, height: 40)
        swipeImg.image = #imageLiteral(resourceName: "icons8-double-up-40 (1)")
        
        self.view.addSubview(right)
        self.view.addSubview(left)
        self.view.addSubview(swipeImg)
        moreView.addSubview(theName)
        moreView.addSubview(theDesc)
    }
    
    
    
    func getProfileInfo()
    {
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let usernameRef = Database.database().reference().child("users").child(uid!)
        
        usernameRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                print("WELL FUCK")
                return }
            let test = snapshot.value as! [String : AnyObject]
            let name = test["username"] as! String
            self.usernameLabel.text = name
            let profileImage = test["url"] as! String
            self.profImg.downloadImage(from: profileImage)
        })
    }
    
    
    
    func loadCells(){
        dispatchGroup.enter()
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let ref = Database.database().reference().child("users").child(uid!).child("publishedWorkouts")
        ref.queryOrderedByValue()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let test = snapshot.value as! [String : AnyObject]
            for(_, value) in test {
                
                let wo = workout()
                
                if let name = value["name"] as? String{
                    
                    wo.name = name
                    print(wo.name)
                    
                }
                if let desc = value["description"] as? String {
                    
                    wo.description = desc
                    print(wo.description)
                }
                if let url = value["imagePath"] as? String{
                    wo.imagePath = url
                    print(wo.imagePath)
                }
                if let pub = value["Published"] as? Bool{
                    wo.published = pub
                }
                if(wo.name != "atempholderworkout")
                {
                    self.workouts.append(wo)
                }
            }
            self.dispatchGroup.leave()
        })
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
    @objc func swipeUp(_ sender: UISwipeGestureRecognizer)
    {
        //moreView.frame = CGRect(x: 0, y: currentView.frame.maxY + (currentView.bounds.height * 0.3), width: currentView.bounds.width, height: currentView.bounds.height * 0.3)
        print("Swiped Up")
        self.view.addSubview(moreView)
        self.view.bringSubviewToFront(self.moreView)
        UIView.animate(withDuration: 0.4, animations: {
            let theHeight = self.currentView.bounds.height * 0.3
            self.moreView.frame = CGRect(x: 0, y: self.currentView.frame.maxY - theHeight, width: self.currentView.bounds.width, height: theHeight)
            
        })
        
    }
    
    @objc func swipeDown(_ sender: UISwipeGestureRecognizer)
    {
        print("Swiped Down")
        self.view.addSubview(moreView)
        self.view.bringSubviewToFront(self.moreView)
        UIView.animate(withDuration: 0.4, animations: {
            self.moreView.frame = CGRect(x: 0, y: self.currentView.frame.maxY + (self.currentView.bounds.height * 0.3), width: self.currentView.bounds.width, height: self.currentView.bounds.height * 0.3)
            
        })
        
    }
    @objc func swipeLeft(_ sender: UISwipeGestureRecognizer)
    {
        print("SwipedLeft")
        if(currentRow+1>=workouts.count)
        {
            return
        }
        currentRow += 1
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
           let theight = (self.view.bounds.height * 0.7) - (self.tabBarHeight)
            self.currentView.frame = CGRect(x: -self.view.bounds.width, y: self.view.bounds.height * 0.3, width: self.view.bounds.width, height: theight)
            
            
            
        }, completion: {finished in
            
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
            self.imgView.image = nil
            self.currentView.removeFromSuperview()
            self.createView()
        }
        )
    }
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer)
    {
        if(currentRow==0)
        {
            return
        }
        currentRow -= 1
        print("Swipedright")
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
            let theight = (self.view.bounds.height * 0.7) - (self.tabBarHeight)
            self.currentView.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height * 0.3, width: self.view.bounds.width, height: theight)
            
            
            
        }, completion: {finished in
            
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
            self.imgView.image = nil
            self.currentView.removeFromSuperview()
            self.createView()
        }
        )
    }
}

