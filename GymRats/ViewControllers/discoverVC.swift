//
//  discoverVC.swift
//  GymRats
//
//  Created by Jonathan Kopp on 12/1/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ChameleonFramework


class discoverVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate{
    
    var discovers = [discoverOBJ]()
    var tabBarHeight = CGFloat()
    var currentView = UIView()
    var infoView = UIView()
    var currentRow = Int()
    var previousView = UIView()
    var likeLabel = UILabel()
    var likeButton = UIButton()
    var theImage = UIImageView()
    var profileImage = UIImageView()
    var dispatchGroup = DispatchGroup()
    var swipeUpDown = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        
        currentRow = 0
        //self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        navView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.6117647059, blue: 1, alpha: 1)
        navView.isOpaque = true
        
        let label = UILabel(frame: CGRect(x:0, y: navView.bounds.height/2-15, width: navView.bounds.width, height: 50))
        label.text = "Trending / Recents"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 35.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        
        
        navView.addSubview(label)
        view.addSubview(navView)
        
        tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        
        
        //loadCells()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
        swipeUP.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUP)
        
        let swipeDOWN = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDOWN(_:)))
        swipeDOWN.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDOWN)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        dispatchGroup.notify(queue: .main) {
            
            self.createView()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(discovers.count > 0)
        {
            discovers = [discoverOBJ]()
            currentRow = 0
        }
        tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        loadCells()
        dispatchGroup.notify(queue: .main) {
            self.createView()
        }
        
    }

    
    func createView()
    {
        let username = UILabel()
        let theName = UILabel()
        let theDesc = UITextView()
        
        if(discovers.count<=0){
            return
        }
        
        if(discovers[currentRow].profileImageView.image == nil)
        {
           discovers[currentRow].profileImageView.downloadImage(from: discovers[currentRow].profileImagePath)
        }
        
        if(discovers[currentRow].img.image == nil)
        {
            discovers[currentRow].img.downloadImage(from: discovers[currentRow].imagePath)
        }
        
        
        tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        let theight = self.view.bounds.height - (80 + tabBarHeight)
        currentView.frame = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: theight)
        
        
        
        
        
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        buttonView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        
        theName.frame = CGRect(x: 5, y: 55, width: currentView.bounds.width-10, height: 35)
        
        
        let userView = UIView(frame: CGRect(x: 0, y: 0, width: currentView.bounds.width, height: 40))
        userView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        
        profileImage.frame = CGRect(x: 0, y: 1, width: 38, height: 38)
        if(discovers[currentRow].profileImageView.image == nil)
        {
            profileImage.downloadImage(from: discovers[currentRow].profileImagePath)
            discovers[currentRow].profileImageView.image = profileImage.image
        }
        else{
            profileImage.image = discovers[currentRow].profileImageView.image
        }
        profileImage.layer.cornerRadius = 19
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        userView.addSubview(profileImage)
        print("tabBarHeight: \(tabBarHeight)")
        username.frame = CGRect(x: 45, y: 0, width: currentView.bounds.width-50, height: 40)
        userView.addSubview(username)
        
        let theHeight =  currentView.bounds.height - (currentView.bounds.height * 0.6)
         infoView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height - (tabBarHeight+130), width: currentView.bounds.width, height: theHeight))
        infoView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        infoView.addSubview(theName)
        
        let deletebutton = UIButton(frame: CGRect(x: currentView.bounds.width - 40, y: 40, width: 40, height: 40))
        deletebutton.setImage(#imageLiteral(resourceName: "icons8-cancel-50"), for: .normal)
        deletebutton.addTarget(self, action:#selector(self.deletePressed), for: .touchUpInside)
        
        let descHeight = infoView.bounds.height - (buttonView.bounds.height)
        theDesc.frame = CGRect(x: 0, y: theName.frame.maxY + 5, width: currentView.bounds.width-5, height: descHeight)
        infoView.addSubview(theDesc)
        theImage.frame = CGRect(x: 0, y: 40, width: currentView.bounds.width, height: currentView.bounds.height)
        
        
        theImage.contentMode = .scaleAspectFill
        
        theImage.clipsToBounds = true
        theImage.image = nil
        if(discovers[currentRow].img.image == nil)
        {
            theImage.downloadImage(from: discovers[currentRow].imagePath)
            discovers[currentRow].img.image = theImage.image
        }else{
            theImage.image = discovers[currentRow].img.image
        }
        
        
        let right = UIImageView(frame: CGRect(x: theImage.bounds.width - 40, y: self.currentView.bounds.height / 2, width: 40, height: 40))
        right.image = #imageLiteral(resourceName: "icons8-rightcopy")
        right.alpha = 0.7
        let left = UIImageView(frame: CGRect(x: 0, y: theImage.bounds.height / 2, width: 40, height: 40))
        left.image = #imageLiteral(resourceName: "icons8left")
        left.alpha = 0.7
        
        
        username.text = discovers[currentRow].username
        username.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        username.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 25)
        username.textAlignment = .left
        username.adjustsFontSizeToFitWidth = true

        theName.text = discovers[currentRow].name
        theName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theName.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 25)
        theName.textAlignment = .left
        theName.adjustsFontSizeToFitWidth = true
        //theName.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        theName.layer.cornerRadius = 10

        theDesc.text = discovers[currentRow].description
        theDesc.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theDesc.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 25)
        theDesc.isEditable = false
        theDesc.backgroundColor = .clear
        theDesc.textAlignment = .left
        
        
        likeButton = UIButton(frame: CGRect(x: 10, y: 5, width: 40, height: 40))
        likeButton.setImage(#imageLiteral(resourceName: "icons8-good-quality-50"), for: .normal)
        let uid = Auth.auth().currentUser?.uid
        
        if(discovers[currentRow].likedBY.contains(uid!))
        {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-good-quality-filled-50 (1)"), for: .normal)
        }
        likeButton.backgroundColor = .clear
        likeButton.addTarget(self, action:#selector(self.likePressed), for: .touchUpInside)
        buttonView.addSubview(likeButton)
        
        likeLabel = UILabel(frame: CGRect(x: likeButton.frame.maxX + 5, y: 0, width: buttonView.bounds.width/2 - 35, height: 50))
        likeLabel.text = String(discovers[currentRow].likes)
        likeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        likeLabel.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 30.0)
        likeLabel.textAlignment = .left
        likeLabel.adjustsFontSizeToFitWidth = true
        buttonView.addSubview(likeLabel)
        
        let widthOfbutton = buttonView.bounds.width * 0.2
        let addButton = UIButton(frame: CGRect(x: (buttonView.bounds.width * 0.8) - 5, y: 5, width: widthOfbutton, height: 40))
        addButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.setTitle("Add?", for: .normal)
        addButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        addButton.addTarget(self, action:#selector(self.addPressed), for: .touchUpInside)
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        buttonView.addSubview(addButton)
        swipeUpDown.alpha = 0.9
        swipeUpDown.image = #imageLiteral(resourceName: "icons8-double-up-40 (1)")
        
        swipeUpDown.frame = CGRect(x: currentView.bounds.width/2-25, y: -25, width: 40, height: 40)
        
        infoView.addSubview(buttonView)
        currentView.addSubview(theImage)
        currentView.addSubview(userView)
        currentView.addSubview(infoView)
        infoView.addSubview(swipeUpDown)
        currentView.addSubview(right)
        currentView.addSubview(left)
        if(uid! == discovers[currentRow].uid)
        {
            currentView.addSubview(deletebutton)
        }
        //currentView.bringSubviewToFront(swipeUpDown)
        //currentView.addSubview(buttonView)
        
        currentView.alpha = 1
        
        
        

        self.view.addSubview(currentView)
        
    }
    
    @objc func deletePressed()
    {
        print("DeletePressed")
        let thename = discovers[currentRow].name
        let nameOfDir = thename?.removeChars(from: thename)
        let ref = Database.database().reference().child("publishedWorkouts").child(nameOfDir! + discovers[currentRow].uid)
        ref.removeValue()
        
        discovers.remove(at: currentRow)
        currentRow = 0
        createView()
        
    }
    
    @objc func addPressed()
    {
        print("addPressed")
        let theLabel = UILabel(frame: CGRect(x: 10, y:self.view.bounds.height , width: self.view.bounds.width-20, height: 60))
        theLabel.text = "Workout added to \(discovers[currentRow].nameOfGroup!)"
        theLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theLabel.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 50.0)
        theLabel.textAlignment = .center
        theLabel.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        theLabel.shadowOffset = CGSize(width: 5, height: 5)
        theLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(theLabel)
        self.view.bringSubviewToFront(theLabel)
        let uid = Auth.auth().currentUser?.uid
        let nameOfGroup = discovers[currentRow].nameOfGroup
        let nameOfGroupDIR = nameOfGroup!.removeChars(from: nameOfGroup)
        
        let nameOfWorkout = discovers[currentRow].name
        let nameOfWorkoutDIR = nameOfWorkout!.removeChars(from: nameOfWorkout)
        
        let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(nameOfGroupDIR)//.child(nameOfWorkoutDIR)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                print("Snapshot does not exist")
                UIView.animate(withDuration: 1.5, animations: {
                    
                    theLabel.frame = CGRect(x: 10, y: self.currentView.bounds.height * 0.6 + 60, width: self.view.bounds.width-20, height: 60)
                    
                }, completion: {finished in
                    
                    theLabel.removeFromSuperview()
                })
                
                let toUpload: [String: Any] = ["Name" : self.discovers[self.currentRow].name, "Description" : self.discovers[self.currentRow].description, "url" : self.discovers[self.currentRow].imagePath, "completion" : false]
                ref.child(nameOfWorkoutDIR).updateChildValues(toUpload)
                return }
            
            let test = snapshot.value as! [String : AnyObject]
            for(_, value) in test {
                
                
                if let name = value["Name"] as? String{
                    
                if(name == self.discovers[self.currentRow].name)
                {
                    
                    theLabel.text = "Workout already exists."
                    UIView.animate(withDuration: 1.5, animations: {

                        print("Went into animate view")
                        theLabel.frame = CGRect(x: 10, y: self.currentView.bounds.height * 0.6 + 60, width: self.view.bounds.width-20, height: 60)
                        
                    }, completion: {finished in
                        
                        theLabel.removeFromSuperview()
                    })
                    print("Workout ALready exists in repositroy")
                    return
                }else{
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        theLabel.frame = CGRect(x: 10, y: self.currentView.bounds.height * 0.6 + 60, width: self.view.bounds.width-20, height: 60)
                        
                    }, completion: {finished in
                        
                        theLabel.removeFromSuperview()
                    })
                    
                     let toUpload: [String: Any] = ["Name" : self.discovers[self.currentRow].name, "Description" : self.discovers[self.currentRow].description, "url" : self.discovers[self.currentRow].imagePath, "completion" : false]
                    ref.child(nameOfWorkoutDIR).updateChildValues(toUpload)
                    
                }
            }
                
            }
            })
        
       
        
    }
    
    @objc func likePressed()
    {
        
        print("Like Pressed")
        print(discovers[currentRow].likedBY)
        let uid = Auth.auth().currentUser?.uid
        
        if(discovers[currentRow].likedBY.contains(uid!))
        {
            return
        }
        
        let nameOfWorkout = discovers[currentRow].name
        let dir = nameOfWorkout!.removeChars(from: nameOfWorkout) + discovers[currentRow].uid
        print(dir)
        let ref = Database.database().reference().child("publishedWorkouts").child(dir)
       
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                print("nope")
                return }
            let test = snapshot.value as! [String : AnyObject]
            var theLikes = test["likes"] as! Int
            print(theLikes)
            theLikes += 1
            
            ref.updateChildValues(["likes" : theLikes])
            
            self.discovers[self.currentRow].likes = theLikes
            self.likeLabel.text = String(self.discovers[self.currentRow].likes)
            UIView.animate(withDuration: 0.5, animations: {
                self.likeButton.setImage(#imageLiteral(resourceName: "icons8-good-quality-filled-50"), for: .normal)
                self.discovers[self.currentRow].likedBY.append(uid!)
                })
            
            ref.child("likedBY").child(uid!).updateChildValues(["uid" : uid!])
        })
    }
    
    
    func loadCells()
    {
        dispatchGroup.enter()
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let ref = Database.database().reference().child("publishedWorkouts")
        ref.queryOrderedByValue()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let test = snapshot.value as! [String : AnyObject]
            
            for(_, value) in test {
                let dis = discoverOBJ()
                if let name = value["name"] as? String{
                    
                    dis.name = name
                    print(dis.name)
                    
                }
                if let username = value["username"] as? String{
                    
                    dis.username = username
                    print(dis.username)
                }
                if let userID = value["uid"] as? String{
                    
                    dis.uid = userID
                    print(dis.uid)
                }
                if let desc = value["description"] as? String {
                    
                    dis.description = desc
                    print(dis.description)
                }
                if let likes = value["likes"] as? Int {
                    dis.likes = likes
                    print(dis.likes)
                }
                if let url = value["imagePath"] as? String{
                    dis.imagePath = url
                    dis.img.downloadImage(from: url)
                    print(dis.imagePath)
                }
                if let profileurl = value["profileURL"] as? String{
                    dis.profileImagePath = profileurl
                    
                }
                if let nameOfTheGroup = value["nameOfGroup"] as? String{
                    dis.nameOfGroup = nameOfTheGroup
                }
                let theName = dis.name
                let nameDIR = theName!.removeChars(from: theName!) + dis.uid
                let ref2 = ref.child(nameDIR).child("likedBY")
                
                ref2.observeSingleEvent(of: .value, with: { snapshot in
                    
                    if !snapshot.exists() {
                        print("DB No values in likedBY")
                        return }
                    let test = snapshot.value as! [String : AnyObject]
                    for(_, value) in test {
                        if let userID = value["uid"] as? String{
                            
                            dis.likedBY.append(userID)
                        }
                    }
                })
                self.discovers.append(dis)
                
            }
            
            self.discovers.sort(by: { $0.likes > $1.likes })
            //self.createView()
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
    
    @objc func swipeLeft(_ sender: UISwipeGestureRecognizer)
    {
        print("Swipe Left")
        if(currentRow+1>=discovers.count)
        {
            return
        }
        currentRow += 1
        //view.insertSubview(previousView, belowSubview: currentView)
       // self.view.sendSubviewToBack(previousView)
        UIView.animate(withDuration: 0.3, animations: {
            
            
            let theight = self.view.bounds.height - (80 + self.tabBarHeight)
            self.currentView.frame = CGRect(x: -self.view.bounds.width, y: 80, width: self.view.bounds.width, height: theight)
            
            
            
        }, completion: {finished in
            
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
            self.currentView.removeFromSuperview()
            self.profileImage.image = nil
            self.createView()
        }
        )
        
    }
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer)
    {
        print("Swipe right")
        if(currentRow==0)
        {
            return
        }
        currentRow -= 1
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
                
            //self.currentView.alpha = 0.0
            let theight = self.view.bounds.height - (80 + self.tabBarHeight)
            self.currentView.frame = CGRect(x: self.view.bounds.width, y: 80, width: self.view.bounds.width, height: theight)
                
        }, completion: {finished in
            
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
            self.currentView.removeFromSuperview()
             self.profileImage.image = nil
            self.createView()
        }
        )
        
        //currentView.removeFromSuperview()
        
        
    }
    @objc func swipeUp(_ sender: UISwipeGestureRecognizer)
    {
        UIView.animate(withDuration: 0.4, animations: {
            let theHeight =  self.currentView.bounds.height - (self.currentView.bounds.height * 0.6)
            self.currentView.bringSubviewToFront(self.infoView)
            self.infoView.frame = CGRect(x: 0, y: self.currentView.bounds.height * 0.6, width:self.currentView.bounds.width , height: theHeight)
            
            self.swipeUpDown.alpha = 0
            })
    }
    
    @objc func swipeDOWN(_ sender: UISwipeGestureRecognizer)
    {
        print("Down")
        UIView.animate(withDuration: 0.4, animations: {
            let theHeight =  self.currentView.bounds.height - (self.currentView.bounds.height * 0.6)
            //self.currentView.bringSubviewToFront(self.infoView)
            self.infoView.frame = CGRect(x: 0, y: self.view.bounds.height - (self.tabBarHeight+130), width: self.currentView.bounds.width, height: theHeight)
            self.swipeUpDown.alpha = 0.9
            
        })
        //self.currentView.bringSubviewToFront(self.swipeUpDown)
    }
    
    
}
