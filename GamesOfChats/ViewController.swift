//
//  ViewController.swift
//  LoginFirebase
//
//  Created by Luiz Alfredo Diniz Hammerli on 07/03/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
       
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if FIRAuth.auth()?.currentUser?.uid == nil{
                
                let loginViewController = LoginViewController()
                loginViewController.messageViewController = self
                self.navigationItem.title = " "
                self.present(loginViewController, animated: true, completion: nil)
            }
            
            self.checkUserData()
        }
        
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleNewMessage))
    }
    
    func handleNewMessage(){
    
        let messageViewController = NewMessageViewController()
        
        let navController = UINavigationController(rootViewController: messageViewController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func checkUserData(){
    
        if FIRAuth.auth()?.currentUser?.uid != nil{
            
            let snapshot = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]{
                    
                    let user:User = User()
                    user.setValuesForKeys(dict)
                    self.setUpNavBarWithUser(user)
                }})
            
            print(snapshot)
        }
    }
    
    func setUpNavBarWithUser(_ user:User){
    
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        //
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        if let imageUrl = user.image{
            profileImage.loadImageWithUrlString(imageUrl)
        }
        containerView.addSubview(profileImage)
        
        
        //
        profileImage.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user.name
        containerView.addSubview(nameLabel)
        
        //
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo:  containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.titleView = titleView
    }
    
    func logOut(){
    
        try! FIRAuth.auth()!.signOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

