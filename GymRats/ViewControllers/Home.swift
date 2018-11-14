//
//  ViewController.swift
//  SwoleMates
//
//  Created by Jonathan Kopp on 10/22/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let backImage = #imageLiteral(resourceName: "backgroundHue")
        let imageView = UIImageView(image: backImage)
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x:0, y: 40, width: view.bounds.width, height: 50))
        label.text = "GymRats"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 42.0)
        label.textAlignment = .center
        view.addSubview(label)
        
        let logoImage = #imageLiteral(resourceName: "logo")
        let logoimageView = UIImageView(image: logoImage)
        logoimageView.frame = CGRect(x: view.bounds.width/2-100, y: 70, width: 200, height: 200)
        view.addSubview(logoimageView)
        
        let label2 = UILabel(frame: CGRect(x:0, y: 250, width: view.bounds.width, height: 50))
        label2.text = "The ultimate fitness"
        label2.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label2.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 35.0)
        label2.textAlignment = .center
        view.addSubview(label2)
        
        let label3 = UILabel(frame: CGRect(x:0, y: 290, width: view.bounds.width, height: 50))
        label3.text = "app."
        label3.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label3.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 35.0)
        label3.textAlignment = .center
        view.addSubview(label3)
        
        let liButton = UIButton(frame: CGRect(x: 10, y: 350, width: view.bounds.width-20, height: 80))
        liButton.backgroundColor = .clear
        liButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30.0)
        liButton.setTitle("Log in", for: .normal)
        liButton.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        liButton.addTarget(self, action:#selector(self.logInPressed), for: .touchUpInside)
        self.view.addSubview(liButton)
        
        let suButton = UIButton(frame: CGRect(x: 10, y: 400, width: view.bounds.width-20, height: 80))
        suButton.backgroundColor = .clear
        suButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30.0)
        suButton.setTitle("Sign up", for: .normal)
        suButton.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        suButton.addTarget(self, action:#selector(self.signUpPressed), for: .touchUpInside)
        self.view.addSubview(suButton)
        
        
        
    }
    
    @objc func logInPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LogInVC
        print("Login Pressed")
        self.present(viewController, animated: false, completion: nil)
    }
    
    @objc func signUpPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signupvc") as! signUpVC
        print("sign up Pressed")
        self.present(viewController, animated: false, completion: nil)
    }
    
}

