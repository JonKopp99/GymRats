//
//  ViewController.swift
//  SwoleMates
//
//  Created by Jonathan Kopp on 10/22/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase

class signUpVC: UIViewController, UITextFieldDelegate {
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var conpasswordTextField: UITextField!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()

    }
    
    
    override func viewDidLayoutSubviews() {
        
        let backImage = #imageLiteral(resourceName: "backgroundHue")
        let imageView = UIImageView(image: backImage)
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(imageView)
        
        
        let logoImage = #imageLiteral(resourceName: "logo")
        let logoimageView = UIImageView(image: logoImage)
        logoimageView.frame = CGRect(x: view.bounds.width/2-100, y: 40, width: 200, height: 200)
        view.addSubview(logoimageView)
        
        nameTextField =  UITextField(frame: CGRect(x: 30, y: 250, width: view.bounds.width-60, height: 30))
        nameTextField.placeholder = "Enter name"
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        nameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
        
        emailTextField =  UITextField(frame: CGRect(x: 30, y: 300, width: view.bounds.width-60, height: 30))
        emailTextField.placeholder = "Enter email"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        self.view.addSubview(emailTextField)
        
        passwordTextField =  UITextField(frame: CGRect(x: 30, y: 350, width: view.bounds.width-60, height: 30))
        passwordTextField.placeholder = "Enter password"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        self.view.addSubview(passwordTextField)
        
        conpasswordTextField =  UITextField(frame: CGRect(x: 30, y: 400, width: view.bounds.width-60, height: 30))
        conpasswordTextField.placeholder = "Confirm password"
        conpasswordTextField.font = UIFont.systemFont(ofSize: 15)
        conpasswordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        conpasswordTextField.autocorrectionType = UITextAutocorrectionType.no
        conpasswordTextField.keyboardType = UIKeyboardType.default
        conpasswordTextField.returnKeyType = UIReturnKeyType.done
        conpasswordTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        conpasswordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        conpasswordTextField.isSecureTextEntry = true
        conpasswordTextField.delegate = self
        
        self.view.addSubview(conpasswordTextField)
        
        
        
        
        //Sign Up
        let liButton = UIButton(frame: CGRect(x: 10, y: 450, width: view.bounds.width-20, height: 80))
        liButton.backgroundColor = .clear
        liButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 40.0)
        liButton.setTitle("Sign up", for: .normal)
        liButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        liButton.addTarget(self, action:#selector(self.signUpPressed), for: .touchUpInside)
        self.view.addSubview(liButton)
        
        //Log in
        let suButton = UIButton(frame: CGRect(x: 10, y: 510, width: view.bounds.width-20, height: 40))
        suButton.backgroundColor = .clear
        suButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 15.0)
        suButton.setTitle("Log in instead.", for: .normal)
        suButton.setTitleColor(#colorLiteral(red: 0.07654192284, green: 0.2319620616, blue: 0.8549019694, alpha: 1), for: .normal)
        suButton.addTarget(self, action:#selector(self.logInPressed), for: .touchUpInside)
        self.view.addSubview(suButton)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        let newText = textField.text!
        print(newText)
        return true
    }
    
    @objc func signUpPressed()
    {
        let name = nameTextField.text
        print(name!)
        let email = emailTextField.text
        print(email!)
        let password = passwordTextField.text
        print(password!)
        let conpassword = conpasswordTextField.text
        print(conpassword!)
        //print("Name \(nameTextField.text) email \(emailTextField.text) password \() conPass \()")
        
        guard  nameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", conpasswordTextField.text != "" else { return}
        
        if passwordTextField.text == conpasswordTextField.text{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if user == user {
                    
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.nameTextField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let userID = Auth.auth().currentUser!.uid
                    
                        let userInfo: [String : Any] = ["uid" : userID,"username" : self.nameTextField.text!]
                    self.ref.child("users").child(userID).setValue(userInfo)
                    self.addDefaultWorkouts(uid: userID)
                    
                                
                    let tabbar:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                    self.present(tabbar, animated: false, completion: nil)
                                
                            }
                        })
    
            
            
        }else{
            print("Password does not match")
    }
        
    }
    
    @objc func logInPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LogInVC
        print("Login Pressed")
        self.present(viewController, animated: false, completion: nil)
    }
    func addDefaultWorkouts(uid: String)
    {
        //let userWorkouts: [String] = ["Chest","Back","Legs","Shoulders","Biceps","Triceps","Core","Progess","Saved"]
        //self.ref.child("users").child(uid).child("Workouts").setValue(userWorkouts)
        //Chest
        var work = Workouts()
        work.name = "Flat Bench"
        work.desc = "Push bar up from chest."
        work.uploadToBase(theName: "Chest", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Back
        work.name = "Lat Pulldown"
        work.desc = "Pull bar down to chest."
        work.uploadToBase(theName: "Back", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Legs
        work.name = "Squat"
        work.desc = "ASS to the grass"
        work.uploadToBase(theName: "Legs", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Shoulders
        work.name = "Military Press"
        work.desc = "Stand up and push dumbells over your head!"
        work.uploadToBase(theName: "Shoulders", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Biceps
        work.name = "Curls"
        work.desc = "Curl them dumbells!!!"
        work.uploadToBase(theName: "Biceps", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Triceps
        work.name = "Tricep Extension"
        work.desc = "Extend them triceps BOY!!!"
        work.uploadToBase(theName: "Triceps", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Core
        work.name = "Sit Ups"
        work.desc = "Everyone knows what sit ups are!"
        work.uploadToBase(theName: "Core", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Progress
        work.name = "My Progress"
        work.desc = "Post pics of your progression!"
        work.uploadToBase(theName: "Progress", uid: uid, img: #imageLiteral(resourceName: "chestHightlighted"))
        //Saved
        work.name = "Beef and Chicken"
        work.desc = "A weird but beautiful combo"
        work.uploadToBase(theName: "Diet", uid: uid, img: #imageLiteral(resourceName: "diet"))
        
    }
    
    
}

struct Workouts{
    
    var name: String!
    var desc: String!
    
    func uploadToBase(theName: String, uid: String, img: UIImage)
    {

        let text2 = name.removeChars(from: name)
        let ref = Database.database().reference().child("users").child(uid).child("Workouts").child(theName).child(text2)
        
       let storage = Storage.storage().reference().child("users").child(uid).child("images").child(text2)
     
        
        //let thedata = img.jpegData(compressionQuality: 0.5)
        let thedata = img.pngData()
        
        storage.putData(thedata!, metadata: nil, completion: {(metadat, err) in
            print("putData Completed")
            if let error = err {
                print("Error in putdata\(error.localizedDescription)")
            }
            storage.downloadURL(completion: {(url, error) in
                if let urly = url?.absoluteString {
                    
                    let toUpload: [String: Any] = ["Name" : self.name, "Description" : self.desc, "url" : urly, "completion" : false]
                    ref.setValue(toUpload)
                    print("Download Url Completed")
                }
                    if error != nil{
                        print("Error in downloadURL\(error!.localizedDescription)")
                    }
            
            
            
        })
            
        })
    }
}
