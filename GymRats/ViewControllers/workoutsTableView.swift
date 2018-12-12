//
//  workoutsTableView.swift
//  GymRats
//
//  Created by Jonathan Kopp on 11/11/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//
import UIKit
import Firebase
import DZNEmptyDataSet

class workoutsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var workouts = [workout]()
    var nameOfGroup: String!
    var currentSelectedIndex: IndexPath!
    let picker = UIImagePickerController()
    var previewImage = UIImageView()
    var previewimageButton = UIButton()
    var previewnameTextField = UITextField()
    var previewtextView = UITextView()
    var keyboardHeight = CGFloat()
    var inView = false
    var inPicView = false
    var editg = false
    //var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        
        loadCells()
        tableView.reloadData()
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(self.singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(singleTap)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height-80)
        tableView.backgroundColor = .white
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let backImage = UIImageView(frame: CGRect(x: 20, y: 40, width: 25, height: 25))
        backImage.image = #imageLiteral(resourceName: "back_arrow")
        
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 75))
        backButton.backgroundColor = .clear
        backButton.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        
        
        
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        navView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navView.isOpaque = true
        
        let addButton = UIButton(frame: CGRect(x: navView.frame.width-65, y: 35, width: 35, height: 35))
        addButton.backgroundColor = .clear
        addButton.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        addButton.addTarget(self, action:#selector(self.addPressed), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x:0, y: navView.bounds.height/2-10, width: navView.bounds.width, height: 50))
        label.text = nameOfGroup!
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 35.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        navView.addSubview(addButton)
        navView.addSubview(backImage)
        navView.addSubview(backButton)
        navView.addSubview(label)
        view.addSubview(navView)
    
        print(nameOfGroup)
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Press the + button to add a workout!"
        
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutsTBCELL", for: indexPath) as! workoutsTBCell
        cell.theImage.downloadImage(from: workouts[indexPath.row].imagePath)
               
        cell.name.text = workouts[indexPath.row].name
        cell.name.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.name.font = UIFont(name: "AvenirNext-Bold", size: 25)
        //cell.name.textAlignment = .center
        cell.name.sizeToFit()
        cell.name.adjustsFontSizeToFitWidth = true
        cell.completeImage.image = #imageLiteral(resourceName: "xMark")
        if(workouts[indexPath.row].completion)
        {
            cell.completeImage.image = #imageLiteral(resourceName: "checkMark")
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.3
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        print("DID select ROW")
        currentSelectedIndex = indexPath

        //tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let uid = Auth.auth().currentUser?.uid
            if(uid == nil)
            {
                perform(#selector(logOutNow),with: nil, afterDelay: 0)
            }
            
            let theName = workouts[indexPath.row].name
            let dir = nameOfGroup.removeChars(from: nameOfGroup)
            let dirWorkout = theName!.removeChars(from: theName)
            let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(dir)
            ref.child(dirWorkout).removeValue()
            let storage = Storage.storage().reference().child("users").child(uid!).child("images").child(dirWorkout)
            storage.delete { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("deleteSuccesfull!")
                }
                
                
                
                
            }
            
            workouts.remove(at: indexPath.row)
            donePressed()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func backPressed()
    {
        if(inPicView)
        {
            donePressed()
            return
        }
        let tabbar:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        tabbar.modalTransitionStyle = .crossDissolve
        self.present(tabbar, animated: true, completion: nil)
    }
    
    @objc func singleTapAction(_ sender: UITapGestureRecognizer)
    {
        if(inView)
        {
            return
        }
        if(inPicView)
        {
            return
        }
        let tapLoc = sender.location(in: self.view)
        if let index  = self.tableView.indexPathForRow(at: tapLoc)
        {
            self.currentSelectedIndex = index
        }
        else
        {
            return
        }
        print(currentSelectedIndex)
        print(tapLoc)
        //let loc = sender.location(in: tableView)
        if (tapLoc.x>=(tableView.bounds.width-100))
        {
            
            if(currentSelectedIndex == nil)
            {
                return
            }
            
            print(currentSelectedIndex.section)
                
            setCompletion(theWorkout: currentSelectedIndex.row)
            
        }
        else{
            inView = true
            viewWorkout()
        }
    }
    
    
    func setCompletion(theWorkout: Int)
    {
        
        let cell = tableView.cellForRow(at: currentSelectedIndex) as! workoutsTBCell
        cell.completeImage.alpha = 0
        let comp = workouts[theWorkout].completion!
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let thename = workouts[theWorkout].name
        let nameOfDir = thename?.removeChars(from: thename)
        
        let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(nameOfGroup).child(nameOfDir!)
        
        if(comp)
        {
            workouts[theWorkout].completion = false
            cell.complete = false
            cell.completeImage.image = #imageLiteral(resourceName: "xMark")
            ref.updateChildValues(["completion": false])
            
        }
        else
        {
           workouts[theWorkout].completion = true
            cell.complete = true
            cell.completeImage.image = #imageLiteral(resourceName: "checkMark")
            ref.updateChildValues(["completion": true])
        }
        UIView.animate(withDuration: 0.5, animations: {
            cell.completeImage.alpha = 1
            
        }, completion: nil)
        
        
    }
    
    
    func viewWorkout()
    {
        inView = true
        
        //
        let theView = UIView(frame: CGRect(x: 20, y: tableView.bounds.height, width: tableView.bounds.width-40, height: tableView.bounds.height-10))
        theView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
        theView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).withAlphaComponent(0.8)
        theView.layer.cornerRadius = 30
        theView.alpha = 0
        
        let rect = UIView(frame: CGRect(x: 0, y: 0, width: theView.frame.width, height: theView.frame.height))
        rect.backgroundColor = .clear
        rect.layer.borderWidth = 4
        rect.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        rect.layer.cornerRadius = 30
        theView.addSubview(rect)
        
        
        let cell = self.tableView.cellForRow(at: currentSelectedIndex) as! workoutsTBCell
        let theimage = UIImageView()
        theimage.image = cell.theImage.image

        theimage.frame = CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2)
        theimage.contentMode = .scaleAspectFit
        theimage.layer.cornerRadius = 30
        
        theView.addSubview(theimage)
        
        let imageButton = UIButton(frame: CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2))
        imageButton.backgroundColor = .clear
        imageButton.addTarget(self, action:#selector(self.imageViewPressed), for: .touchUpInside)
        
        theView.addSubview(imageButton)
        
       
        
        
        let nameTextField =  UITextField(frame: CGRect(x: 60, y:theimage.bounds.height + 15, width: theView.bounds.width-120, height: 30))
        nameTextField.text = workouts[currentSelectedIndex.row].name
        nameTextField.font = UIFont(name: "AvenirNext-Medium", size: 17)
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        nameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextField.delegate = self
        nameTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.borderWidth = 2
        nameTextField.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        nameTextField.textAlignment = .center
        nameTextField.isEnabled = false
        theView.addSubview(nameTextField)
        
        
        
        
  
        let doneButton = UIButton(frame: CGRect(x: 10, y: theView.bounds.height-50, width: theView.bounds.width/2-20, height: 35))
        doneButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        doneButton.setTitle("Close", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        doneButton.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        doneButton.layer.cornerRadius = 10
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        
        
        
        
        let editButton = UIButton(frame: CGRect(x: theView.bounds.width/2+10, y: theView.bounds.height-50, width: theView.bounds.width/2-20, height: 35))
        editButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        editButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        editButton.addTarget(self, action:#selector(self.editPressed), for: .touchUpInside)
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        theView.addSubview(doneButton)
        theView.addSubview(editButton)
        
        let publishButton = UIButton(frame: CGRect(x: 30, y: editButton.frame.minY - 37.5, width: theView.bounds.width-60, height: 35))
        publishButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        publishButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        publishButton.setTitle("Publish workout to discover?", for: .normal)
        publishButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        publishButton.addTarget(self, action:#selector(self.publishPressed), for: .touchUpInside)
        publishButton.titleLabel?.adjustsFontSizeToFitWidth = true
        publishButton.layer.cornerRadius = 10
        publishButton.layer.borderWidth = 2
        publishButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        theView.addSubview(publishButton)
        
        let textViewHeight = theView.bounds.height - (theimage.bounds.height+50) - (90)
        let textView = UITextView(frame: CGRect(x: 10, y: theimage.bounds.height+50, width: theView.bounds.width-20, height: textViewHeight))
        textView.text = workouts[currentSelectedIndex.row].description
        textView.textAlignment = NSTextAlignment.left
        textView.backgroundColor = .white
        textView.textColor = UIColor.black
        //textView.font = UIFont(name: "Verdana", size: 17)
        textView.font = UIFont(name: "AvenirNext-Medium", size: 17)
        textView.isSelectable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.layer.cornerRadius = 10
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        textView.isEditable = false
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = UIReturnKeyType.done
        textView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        theView.addSubview(textView)
        
        
        view.addSubview(theView)
        
        UIView.animate(withDuration: 0.3, animations: {
            theView.frame = CGRect(x: 20, y: self.tableView.frame.minY+5, width: self.tableView.bounds.width-40, height: self.tableView.bounds.height-10)
            
            theView.alpha = 1
            
        }, completion: nil)
    }

        
    @objc func publishPressed()
    {
        print("publishPressed")
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let theName = workouts[currentSelectedIndex.row].name
        let dirWorkout = theName!.removeChars(from: theName)
        
        let publishDirName = dirWorkout + uid!
        print(publishDirName)
        let ref2 = Database.database().reference().child("publishedWorkouts").child(publishDirName)
        let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(nameOfGroup).child(dirWorkout).child("Published")
        ref.setValue(true)
        
        let imagePath = workouts[currentSelectedIndex.row].imagePath
        let desc = workouts[currentSelectedIndex.row].description
        let usernameRef = Database.database().reference().child("users").child(uid!)
        
        var username = ""
        usernameRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                print("WELL FUCK")
                return }
            let test = snapshot.value as! [String : AnyObject]
            print(test)
            let name = test["username"] as! String
            
            let profileImage = test["url"] as! String
            username = name
            let publishUpload: [String: Any] = ["name" : theName!, "description" : desc!, "imagePath" : imagePath!, "Published": true]
            usernameRef.child("publishedWorkouts").child(theName!).setValue(publishUpload)
            let toUpload: [String: Any] = ["name" : theName!, "description" : desc!, "imagePath" : imagePath!,"likes" : 0,"username" : username, "uid" : uid!, "nameOfGroup" : self.nameOfGroup, "profileURL" : profileImage]
            
            ref2.setValue(toUpload)
            
        let likeToUpload: [String: Any] = ["uid" : "theUser"]
            
            ref2.child("likedBY").child(uid!).setValue(likeToUpload)
        })
        
        
        
        
        
        
        let tabbar:UITabBarController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        tabbar.selectedIndex = 1
        
        tabbar.modalTransitionStyle = .crossDissolve
        self.present(tabbar, animated: true, completion: nil)
    }
    

    @objc func editPressed()
    {
        donePressed()
        inView = true
        editg = true
        
        
        addWorkout()
    }
    
    func addWorkout()
    {
        var cell = workoutsTBCell()
        if editg
        {
            cell = self.tableView.cellForRow(at: currentSelectedIndex) as! workoutsTBCell
        }
        let theView = UIView(frame: CGRect(x: 20, y: tableView.bounds.height, width: tableView.bounds.width-40, height: tableView.bounds.height-10))
        theView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.8)
        theView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).withAlphaComponent(0.8)
        theView.layer.cornerRadius = 30
        theView.alpha = 0
        
        let rect = UIView(frame: CGRect(x: 0, y: 0, width: theView.frame.width, height: theView.frame.height))
        rect.backgroundColor = .clear
        rect.layer.borderWidth = 4
        rect.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        rect.layer.cornerRadius = 30
        
        //let label = UILabel(frame: CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2))
        previewImage.frame = CGRect(x: theView.bounds.minX+15, y: theView.bounds.minY+15, width: 100, height: 100)
        previewImage.contentMode = .scaleToFill
        previewImage.layer.cornerRadius = 20
        
        
        
        previewimageButton = UIButton(frame: CGRect(x: theView.bounds.minX+15, y: theView.bounds.minY+15, width: 100, height: 100))
        previewimageButton.backgroundColor = .clear
        previewimageButton.setTitle("Select Image", for: .normal)
        
        previewimageButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        previewimageButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        previewimageButton.setTitleShadowColor(.black, for: .normal)
        previewimageButton.addTarget(self, action:#selector(self.imagePicker), for: .touchUpInside)
        previewimageButton.layer.borderWidth = 2
        previewimageButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        
        let widthOfName = (theView.bounds.width - previewImage.frame.maxX) - 15
        previewnameTextField =  UITextField(frame: CGRect(x: previewImage.bounds.width+20, y:previewImage.bounds.height/2-5, width: widthOfName, height: 30))
        previewnameTextField.placeholder = "Enter name of the workout!"
        
        if(editg)
        {
            previewnameTextField.placeholder = ""
            previewnameTextField.isEnabled = false
        }
        previewnameTextField.font = UIFont(name: "AvenirNext-Medium", size: 17)
        previewnameTextField.autocorrectionType = UITextAutocorrectionType.no
        previewnameTextField.keyboardType = UIKeyboardType.default
        previewnameTextField.returnKeyType = UIReturnKeyType.done
        previewnameTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        previewnameTextField.contentVerticalAlignment = .center
        previewnameTextField.delegate = self
        previewnameTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        previewnameTextField.layer.cornerRadius = 10
        previewnameTextField.layer.borderWidth = 2
        previewnameTextField.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        previewnameTextField.textAlignment = .center
        previewnameTextField.adjustsFontSizeToFitWidth = true
        
        
        previewtextView  = UITextView(frame: CGRect(x: 10, y: previewImage.bounds.height+20, width: theView.bounds.width-20, height: theView.bounds.height * 0.3))
        previewtextView.delegate = self
        previewtextView.textAlignment = .left
        previewtextView.backgroundColor = .white
        previewtextView.textColor = UIColor.black
        previewtextView.font = UIFont(name: "AvenirNext-Medium", size: 17)
        previewtextView.isSelectable = true
        previewtextView.dataDetectorTypes = UIDataDetectorTypes.link
        previewtextView.layer.cornerRadius = 10
        previewtextView.autocorrectionType = .yes
        previewtextView.spellCheckingType = UITextSpellCheckingType.yes
        previewtextView.isEditable = true
        previewtextView.keyboardType = UIKeyboardType.default
        previewtextView.returnKeyType = .done
        
        previewtextView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        previewtextView.layer.cornerRadius = 10
        previewtextView.layer.borderWidth = 2
        previewtextView.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        
        
        var ypos = theView.bounds.height-50
        if(keyboardHeight>0)
        {
            ypos = theView.bounds.height-keyboardHeight
        }
        
        let closeButton = UIButton(frame: CGRect(x: 10, y: ypos-30, width: theView.bounds.width/2-20, height: 30))
        closeButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        closeButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        closeButton.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        closeButton.layer.cornerRadius = 10
        closeButton.layer.borderWidth = 2
        closeButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        let doneButton = UIButton(frame: CGRect(x: theView.bounds.width/2+10, y: ypos-30, width: theView.bounds.width/2-20, height: 30))
        doneButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 30.0)
        doneButton.setTitle("Add", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        doneButton.addTarget(self, action:#selector(self.addWorkoutPressed), for: .touchUpInside)
        doneButton.layer.cornerRadius = 10
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        if(editg)
        {
            previewimageButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            previewimageButton.setTitle("Change Image?", for: .normal)
            previewImage.image = cell.theImage.image
            previewnameTextField.text = cell.name.text
            previewtextView.text = workouts[currentSelectedIndex.row].description
            
        }
        
        theView.addSubview(rect)
        theView.addSubview(previewImage)
        theView.addSubview(previewimageButton)
        theView.addSubview(previewnameTextField)
        theView.addSubview(previewtextView)
        theView.addSubview(closeButton)
        theView.addSubview(doneButton)
        view.addSubview(theView)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            theView.frame = CGRect(x: 20, y: self.tableView.frame.minY+5, width: self.tableView.bounds.width-40, height: self.tableView.bounds.height-10)
            
            theView.alpha = 1
            
        }, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        //print("There has been a touch!")
        //let touch = touches.first!
        //let location = touch.location(in: self.tableView)
        //print("X: \(location.x)")
        //print("Y: \(location.y)")
        
        
        
        super.touchesBegan(touches,  with: event)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //print("TextViewChangeCalledOn")
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    @objc func imageViewPressed()
    {
        //donePressed()
        inPicView = true
        print("ImageViewPResed")
        let cell = tableView.cellForRow(at: currentSelectedIndex) as! workoutsTBCell
        let tbFrame = CGRect(x: 0, y: 80, width: tableView.bounds.width, height: tableView.bounds.height)
        let theFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        let backgroundView = UIView(frame: theFrame)
        backgroundView.backgroundColor = .white
        
        let doneButton = UIButton(frame: theFrame)
        doneButton.backgroundColor = .clear
        doneButton.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        
        let imageView = UIImageView()
        //imageView.downloadImage(from: workouts[currentSelectedIndex.row].imagePath)
        imageView.image = cell.theImage.image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = tbFrame
        imageView.alpha = 0
        
        
        backgroundView.addSubview(imageView)
        self.view.addSubview(backgroundView)
        self.view.addSubview(doneButton)
        
        UIView.animate(withDuration: 0.3, animations: {
           
            imageView.alpha = 1
            
        }, completion: nil)
    }
    
    @objc func imagePicker()
    {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let theimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            print("IT WORKED")
           
            previewImage.image = theimage
            self.previewimageButton.setTitle("", for: .normal)
        }
        
        
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func addPressed()
    {
        addWorkout()
        inView = true
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
        previewImage = UIImageView()
        inView = false
        inPicView = false
    }
    
    @objc func addWorkoutPressed()//theName: String, uid: String, img: UIImage
    {
        if(editg)
        {
            workouts.remove(at: self.currentSelectedIndex.row)
            tableView.deleteRows(at: [self.currentSelectedIndex], with: .fade)
        }
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let theName = previewnameTextField.text!
        let img = previewImage.image!
        let desc = previewtextView.text!
        
        print("addWorkoutPressed")
        
        let dir = nameOfGroup.removeChars(from: nameOfGroup)
        let dirWorkout = theName.removeChars(from: theName)
        let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(dir).child(dirWorkout)
        
        let storage = Storage.storage().reference().child("users").child(uid!).child("images").child(dirWorkout)
        
        let wo = workout()
        //let thedata = img.jpegData(compressionQuality: 0.5)
        let thedata = img.jpegData(compressionQuality: 0.1)
        
        storage.putData(thedata!, metadata: nil, completion: {(metadat, err) in
            print("putData Completed")
            if let error = err {
                print("Error in putdata\(error.localizedDescription)")
            }
            storage.downloadURL(completion: {(url, error) in
                if let urly = url?.absoluteString {
                    
                    let toUpload: [String: Any] = ["Name" : theName, "Description" : desc, "url" : urly, "completion" : false, "Published" : false]
                    ref.setValue(toUpload)
                    print("Download Url Completed")
                    wo.completion = false; wo.description = desc; wo.imagePath = urly; wo.name = theName
                    self.workouts.append(wo)
                    self.tableView.reloadData()
                }
                if error != nil{
                    print("Error in downloadURL\(error!.localizedDescription)")
                }
                
                
                
            })
            self.editg = false
        })
        
        
        
        
        
        
        
        for subview in self.view.subviews {
            if subview is UITableView || subview is UITableViewCell
            {
                print("Almost")
            }
            else{
                subview.removeFromSuperview()
            }
        }
        inView = false
        previewImage = UIImageView()
    }
    
    
    func loadCells()
    {
        let uid = Auth.auth().currentUser?.uid
        if(uid == nil)
        {
            perform(#selector(logOutNow),with: nil, afterDelay: 0)
        }
        let ref = Database.database().reference().child("users").child(uid!).child("Workouts").child(nameOfGroup)
        ref.queryOrderedByValue()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let test = snapshot.value as! [String : AnyObject]
            for(_, value) in test {
                
                let wo = workout()
                
                if let name = value["Name"] as? String{
                    
                    wo.name = name
                    print(wo.name)
                   
                }
                if let desc = value["Description"] as? String {
                    
                    wo.description = desc
                    print(wo.description)
                }
                if let url = value["url"] as? String{
                    wo.imagePath = url
                    print(wo.imagePath)
                }
                if let completion = value["completion"] as? Bool{
                    
                    wo.completion = completion
                    print(wo.completion)
                }
                if(wo.name != "atempholderworkout")
                {
                    self.workouts.append(wo)
                    self.tableView.reloadData()
                }
            }
        })
        tableView.reloadData()
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            previewtextView.frame = CGRect(x: previewtextView.frame.minX, y: previewtextView.frame.minY, width: previewtextView.bounds.width, height: keyboardHeight)
        }
    }
    
}

extension UIImageView {
    func downloadImage(from imgURL: String!)
    {
        if(imgURL == nil)
        {
//            print("Image does not exist")
//            self.image = #imageLiteral(resourceName: "frontskeleton")
            return
        }
       
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if(imgURL == nil)
            {
                self.image = #imageLiteral(resourceName: "frontskeleton")
                return
            }
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    }
}

extension NSString{
    func removeChars(from theString: String!)->String
    {
        var newString = theString.replacingOccurrences(of: " ",with: "")
        newString = newString.replacingOccurrences(of: " ",with: "")
        newString = newString.replacingOccurrences(of: ".", with: "")
        newString = newString.replacingOccurrences(of: "#", with: "")
        newString = newString.replacingOccurrences(of: "$", with: "")
        newString = newString.replacingOccurrences(of: "[", with: "")
        newString = newString.replacingOccurrences(of: "]", with: "")
        newString = newString.replacingOccurrences(of: "-", with: "")
        
        
        return newString
    }
    
    
}



