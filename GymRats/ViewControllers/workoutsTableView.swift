//
//  workoutsTableView.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/11/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//
import UIKit
class workoutsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var nameOfGroup: String!
    var currentSelectedIndex: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(self.singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height-160)
        tableView.backgroundColor = .white
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let backButton = UIButton(frame: CGRect(x: 20, y: 40, width: 25, height: 25))
        backButton.backgroundColor = .clear
        backButton.setImage(#imageLiteral(resourceName: "back_arrow"), for: .normal)
        backButton.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        
        
        
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        navView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navView.isOpaque = true
        
        let addView = UIView(frame: CGRect(x: 0, y: view.bounds.height-80, width: view.bounds.width, height: 80))
        addView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        addView.isOpaque = true
        
        let addButton = UIButton(frame: CGRect(x: addView.frame.width/2-25, y: addView.frame.height/2-30, width: 50, height: 50))
        addButton.backgroundColor = .clear
        addButton.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        addButton.addTarget(self, action:#selector(self.addPressed), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x:0, y: navView.bounds.height/2-10, width: navView.bounds.width, height: 50))
        label.text = nameOfGroup!
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 35.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        addView.addSubview(addButton)
        view.addSubview(addView)
        navView.addSubview(backButton)
        navView.addSubview(label)
        view.addSubview(navView)
    
        print(nameOfGroup)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutsTBCELL", for: indexPath) as! workoutsTBCell
        cell.theImage.image = #imageLiteral(resourceName: "SwoleMatesLogo copy")
        cell.name.text = "Name"
        cell.name.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.name.font = UIFont(name: "AvenirNext-Bold", size: 25)
        //cell.name.textAlignment = .center
        cell.name.sizeToFit()
        cell.name.adjustsFontSizeToFitWidth = true
       cell.completeImage.image = #imageLiteral(resourceName: "xMark")
        cell.complete = false
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        currentSelectedIndex = indexPath

        //tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    @objc func backPressed()
    {
        let tabbar:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        self.present(tabbar, animated: false, completion: nil)
    }
    
    @objc func singleTapAction(_ sender: UITapGestureRecognizer)
    {
        let loc = sender.location(in: tableView)
        if loc.y >= 0
        {
        let cell = tableView.cellForRow(at: currentSelectedIndex) as! workoutsTBCell
        if(cell.complete==false)
        {
            cell.complete = true
            cell.completeImage.image = #imageLiteral(resourceName: "checkMark")
        }
        else
        {
            cell.complete = false
            cell.completeImage.image = #imageLiteral(resourceName: "xMark")
        }
        }
    }
    @objc func doubleTapAction(_ sender: UITapGestureRecognizer)
    {
        let loc = sender.location(in: tableView)
        if loc.y >= 0
        {
        viewWorkout()
        }
    }
    
    func viewWorkout()
    {
        let theView = UIView(frame: CGRect(x: 20, y: 100, width: tableView.bounds.width-40, height: tableView.bounds.height-100))
        theView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.8)
        theView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).withAlphaComponent(0.8)
        theView.layer.cornerRadius = 30
        
        let rect = UIView(frame: CGRect(x: 0, y: 0, width: theView.frame.width, height: theView.frame.height))
        rect.backgroundColor = .clear
        rect.layer.borderWidth = 4
        rect.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        rect.layer.cornerRadius = 30
        theView.addSubview(rect)
        
        let theimage = UIImageView(image: #imageLiteral(resourceName: "SwoleMatesLogo copy"))
        theimage.frame = CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2)
        theimage.contentMode = .scaleAspectFit
        theimage.layer.cornerRadius = 30
        
        theView.addSubview(theimage)
        
        let imageButton = UIButton(frame: CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2))
        imageButton.backgroundColor = .clear
        //imageButton.addTarget(self, action:#selector(self.imagePicker), for: .touchUpInside)
        theView.addSubview(imageButton)
        
        let textView = UITextView(frame: CGRect(x: 10, y: theimage.bounds.height+10, width: theView.bounds.width-20, height: theView.bounds.height * 0.3))
        textView.textAlignment = NSTextAlignment.justified
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.black
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "Verdana", size: 17)
        textView.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        textView.isSelectable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.layer.cornerRadius = 10
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        textView.isEditable = true
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = UIReturnKeyType.done
        textView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        theView.addSubview(textView)
        
        
  
        let doneButton = UIButton(frame: CGRect(x: theView.bounds.width/2-50, y: theView.bounds.height-80, width: 100, height: 60))
        doneButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        doneButton.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        doneButton.layer.cornerRadius = 10
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        theView.addSubview(doneButton)
        
        
        
        view.addSubview(theView)
    }
    @objc func addPressed()
    {
        viewWorkout()
    }
    @objc func donePressed()
    {
        print("DonePressed")
        for subview in self.view.subviews {
            if subview is UITableView || subview is UITableViewCell
            {
                print("Almost")
            }
            else{
                subview.removeFromSuperview()
            }
        }
    }
    
    
    }


