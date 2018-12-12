//
//  searchVC.swift
//  GymRats
//
//  Created by Jonathan Kopp on 12/5/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DZNEmptyDataSet

class searchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

    @IBOutlet weak var tableView: UITableView!
    var users = [searchOBJ]()
    var searches = Int()
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        navView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navView.isOpaque = true
        searchBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        searches = 0
        let label = UILabel(frame: CGRect(x:0, y: navView.bounds.height/2-10, width: navView.bounds.width, height: 50))
        label.text = "Search"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-HeavyItalic", size: 35.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        
        navView.addSubview(label)
        view.addSubview(navView)
        
        searchBar.frame = CGRect(x: 0, y: navView.frame.maxY, width: view.bounds.width, height: 60)
        searchBar.returnKeyType = .done
        
        let tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        let tableviewHeight = self.view.bounds.height - (searchBar.frame.maxY + tabBarHeight)
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: view.bounds.width, height: tableviewHeight)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var str = "Search for users😄"
        if(searches>0)
        {
            str = "No users found 😰"
        }
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//
//        var str = "Search for users!"
//        if(searches>0)
//        {
//            str = "No users found 😰"
//        }
//        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        if(users.count>0)
        {
            cell.name.text = users[indexPath.row].name
            cell.uid = users[indexPath.row].uid
            cell.img.downloadImage(from: users[indexPath.row].imagePath)
            cell.addSubview(cell.img)
            cell.name.textAlignment = .left
        
        
        cell.name.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.name.font = UIFont(name: "AvenirNext-Bold", size: 25)
        cell.name.sizeToFit()
        cell.name.adjustsFontSizeToFitWidth = true
        cell.uid = "uid"
        
        }
        return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(users[indexPath.row].uid)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        searchForUser(theName: searchBar.text!)
        searchBar.resignFirstResponder()
        
    }
    
    func searchForUser(theName: String)
    {
        searches = 1
        users = [searchOBJ]()
        print("Search Called On")
        let ref = Database.database().reference().child("users")
        
        ref.queryOrderedByValue()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                print("snapshot not exist fam")
                return }
            let test = snapshot.value as! [String : AnyObject]
            for(_, value) in test {
                
                let user = searchOBJ()

                if let name = value["username"] as? String{
                    
                    print(name)
                    if(name.lowercased()  == theName.lowercased())
                    {
                        user.name = name
                        if let theUid = value["uid"] as? String{
                            user.uid = theUid
                            
                        }
                        if let theURL = value["url"] as? String{
                            user.imagePath = theURL
                            user.img.downloadImage(from: theURL)
                        }
                        self.users.append(user)
                    }
                    
                    self.tableView.reloadData()
                }
//                if(self.users.count<=0)
//                {
//                    self.theSearchMessage = "No users found 😰"
//                }
            }
            
        })
        
        
        
        
    }
}
