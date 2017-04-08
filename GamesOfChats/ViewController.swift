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
                
                self.present(LoginViewController(), animated: true, completion: nil)
                
            }else{
                
                 self.checkUserData()
            }
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
                    
                    self.navigationItem.title = dict["name"] as! String?
                    
                }})
            
            print(snapshot)
        }
    }
    
    func logOut(){
    
        try! FIRAuth.auth()!.signOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

