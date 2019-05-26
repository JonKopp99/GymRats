//
//  ViewController.swift
//
//  Created by Jonathan Kopp on 10/22/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController, UITextFieldDelegate {
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        emailTextField =  UITextField(frame: CGRect(x: 30, y: 250, width: view.bounds.width-60, height: 30))
        emailTextField.placeholder = "Enter username"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        self.view.addSubview(emailTextField)
        
        passwordTextField =  UITextField(frame: CGRect(x: 30, y: 300, width: view.bounds.width-60, height: 30))
        passwordTextField.placeholder = "Enter password"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
        
        
        
        
        
        let liButton = UIButton(frame: CGRect(x: 10, y: 350, width: view.bounds.width-20, height: 80))
        liButton.backgroundColor = .clear
        liButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 40.0)
        liButton.setTitle("Log in", for: .normal)
        liButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        liButton.addTarget(self, action:#selector(self.logInPressed), for: .touchUpInside)
        self.view.addSubview(liButton)
        
        let suButton = UIButton(frame: CGRect(x: 10, y: 410, width: view.bounds.width-20, height: 40))
        suButton.backgroundColor = .clear
        suButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 15.0)
        suButton.setTitle("Have an account? Sign up instead.", for: .normal)
        suButton.setTitleColor(#colorLiteral(red: 0.07654192284, green: 0.2319620616, blue: 0.8549019694, alpha: 1), for: .normal)
        suButton.addTarget(self, action:#selector(self.signUpPressed), for: .touchUpInside)
        self.view.addSubview(suButton)
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        let newText = textField.text!
        print(newText)
        return true
    }
    
    @objc func logInPressed()
    {
        guard emailTextField.text != "", passwordTextField.text != "" else {return}
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error)
            in
            
            if let error = error{
                print(error.localizedDescription)
            }
            
            if user == user{
                let tabbar:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.present(tabbar, animated: false, completion: nil)
            }
        })
    }
    
    @objc func signUpPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signupvc") as! signUpVC
        print("sign up Pressed")
        self.present(viewController, animated: false, completion: nil)
    }
    
    
}

