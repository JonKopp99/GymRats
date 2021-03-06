//
//  ViewController.swift
//  SwoleMates
//
//  Created by Jonathan Kopp on 10/22/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class workoutsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    @IBOutlet var tabBar: UITabBarItem!
    
    var navcontroller = UINavigationController()
    var workouts = [workoutsCell]()
    let picker = UIImagePickerController()
    var tempImage = UIImage()
    var tempImages = [UIImage]()
    var tempLabels = [String]()
    var currentCell = Int()
    var cellImageCtr = 0
    var inView = false
   
    @IBOutlet weak var workoutCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        workoutCV.delegate = self
        workoutCV.dataSource = self
        cellImageCtr = 0
        workoutCV.reloadData()
        tempImage = #imageLiteral(resourceName: "backgroundHue")
        populateTempCells()
        
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(self.singleTapAction(_:)))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NumOfItemsInSection")
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        workouts = []
        print("CellForItemAt")
        let cell = workoutCV.dequeueReusableCell(withReuseIdentifier: "workoutsCell", for: indexPath) as! workoutsCell
        
        cell.image.image = tempImages[cellImageCtr]
        //layout for the label
        cell.nanme.text = tempLabels[cellImageCtr]
        cell.nanme.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.nanme.font = UIFont(name: "Avenir-MediumOblique", size: 25)
        cell.nanme.textAlignment = .center
        //cell.nanme.sizeToFit()
        cell.nanme.adjustsFontSizeToFitWidth = true
        
        
        
        workouts.append(cell)
        cellImageCtr+=1
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print("SizeForItenAt")
        
        return CGSize(width: workoutCV.bounds.width * 0.325, height: workoutCV.bounds.height * 0.31)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("NumberOfSections")
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        self.currentCell = getLocatation(path: indexPath)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }*/
    
    
    override func viewDidLayoutSubviews() {
 
        if let test = self.tabBarController?.tabBar.frame.height
        {
            print(test)
            workoutCV.frame = CGRect(x: 0.0, y: 0.0,width: view.bounds.width, height: view.bounds.height-test)
            workoutCV.backgroundColor = .white
        }
        
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        workoutCV.collectionViewLayout = layout
        //workoutCV.frame = CGRect(x: 0.0, y: 0.0,width: view.bounds.width, height: view.bounds.height-height)
    }
    
    
    
    func populateTempCells()
    {
        var ctr = 0
        while(ctr<9)
        {
            print(ctr)
            tempImages.append(#imageLiteral(resourceName: "frontskeleton"))
            //tempLabels.append("Empty")
            ctr+=1
        }
        //0
        tempLabels.append("Chest")
        tempImages[0] = #imageLiteral(resourceName: "chestHightlighted")
        //1
        tempLabels.append("Back")
        tempImages[1] = #imageLiteral(resourceName: "backHighlighted")
        //2
        tempLabels.append("Legs")
        tempImages[2] = #imageLiteral(resourceName: "legsHighlighted")
        //3
        tempLabels.append("Shoulders")
        tempImages[3] = #imageLiteral(resourceName: "shouldersHighlighted")
        //4
        tempLabels.append("Biceps")
        tempImages[4] = #imageLiteral(resourceName: "bicepsHighlighted")
        //5
        tempLabels.append("Triceps")
        tempImages[5] = #imageLiteral(resourceName: "tricepsHighlighted")
        //6
        tempLabels.append("Core")
        tempImages[6] = #imageLiteral(resourceName: "coreHighlighted")
        //7
        tempLabels.append("Progress")
        tempImages[7] = #imageLiteral(resourceName: "progress2")
        //8
        tempLabels.append("Diet")
        tempImages[8] = #imageLiteral(resourceName: "diet")
    }

    func getLocatation(path: IndexPath)->Int
    {
        let sec = path.section
        let row = path.row
        if(sec==0)
        {
            return sec + row
        }
        else if(sec == 1)
        {
            return 3 + row
        }
        else
        {
            return 6 + row
        }
    }
    @objc func singleTapAction(_ sender: Any)
    {
        if(inView==false)
        {
        print("Single tap!")
        let tbvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "workoutsTB") as! workoutsTableView
            tbvc.modalTransitionStyle = .crossDissolve
        tbvc.nameOfGroup = tempLabels[currentCell]
        self.present(tbvc, animated: true, completion: nil)
            
        }
    }
    
    
    
    @objc func doubleTapAction(_ sender: Any)
    {
        if(inView==false)
        {
        print("Double tap tap!")
        previewImage(previewImage: tempImages[currentCell])
        inView = true
        }
    }
    
    func previewImage(previewImage: UIImage)
    {
        let theView = UIView(frame: CGRect(x: 20, y: view.bounds.height, width: workoutCV.bounds.width-40, height: workoutCV.bounds.height-200))
        theView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
        theView.layer.cornerRadius = 30
        theView.alpha = 0
        let rect = UIView(frame: CGRect(x: 0, y: 0, width: theView.frame.width, height: theView.frame.height))
        rect.backgroundColor = .clear
        rect.layer.borderWidth = 4
        rect.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        rect.layer.cornerRadius = 30
        theView.addSubview(rect)
        
        let theimage = UIImageView(image: previewImage)
        theimage.frame = CGRect(x: 40, y: 10, width: theView.bounds.width-80, height: theView.bounds.height/2)
        theimage.contentMode = .scaleAspectFit
        theimage.layer.cornerRadius = 30
        //theimage.clipsToBounds = true
        theView.addSubview(theimage)
        
        let nameTextField =  UITextField(frame: CGRect(x: 60, y: theView.bounds.height/2+50, width: theView.bounds.width-120, height: 30))
        nameTextField.text = tempLabels[currentCell]
        nameTextField.font = UIFont.systemFont(ofSize: 15)
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
        
        let doneButton = UIButton(frame: CGRect(x: theView.bounds.width/2-50, y: theView.bounds.height-100, width: 100, height: 60))
        doneButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        doneButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 30.0)
        doneButton.setTitle("Close", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        doneButton.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        doneButton.layer.cornerRadius = 10
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        theView.addSubview(doneButton)
        
        
        
        self.view.addSubview(theView)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            theView.frame = CGRect(x: 20, y: 100, width: self.workoutCV.bounds.width-40, height: self.workoutCV.bounds.height-200)
            theView.alpha = 1
        
        }, completion: nil)
        
    }
    
    

    
    @objc func donePressed()
    {
        print("DonePressed")
        for subview in self.view.subviews {
            if subview is UICollectionView || subview is UICollectionViewCell
            {
                print("Almost")
            }
            else{
                subview.removeFromSuperview()
            }
        }
        self.inView = false
    }
    
    
}

