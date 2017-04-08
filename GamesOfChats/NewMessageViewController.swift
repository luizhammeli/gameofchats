//
//  MessageViewController.swift
//  GamesOfChats
//
//  Created by Luiz Alfredo Diniz Hammerli on 02/04/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMainView))
        
        self.tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        fetchUsers()
    }
    
    func backToMainView(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if let name = users[indexPath.row].name{
            
            cell.textLabel?.text = name
        }
        
        if let email = users[indexPath.row].email{
            
            cell.detailTextLabel?.text = email
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return users.count
    }
    
    func fetchUsers(){
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            
            let dic = snapshot.value as! [String:AnyObject]
            let user = User()
            user.setValuesForKeys(dic)
            self.users.append(user)
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        })
    }
}
