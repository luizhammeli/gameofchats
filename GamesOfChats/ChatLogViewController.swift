//
//  showChatControllerCollectionViewController.swift
//  GamesOfChats
//
//  Created by Luiz Alfredo Diniz Hammerli on 12/04/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate {

    var user: User?{
    
        didSet{
        
            navigationItem.title = user?.name
        }
    }
    
    let containerView:UIView = {
    
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.red
        
        return view
        
    }()
    
    let sendButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    
    }()
    
    let messageTextField:UITextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter with message..."
        
        return textField
        
    }()
    
    let separatorContainerView: UIView = {
    
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        //view.tintColor = UIColor.black
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.white
        addViews()
        messageTextField.delegate = self
        setUpViews()
    }
    
    func addViews()
    {
        self.view.addSubview(containerView)
        self.view.addSubview(sendButton)
        self.view.addSubview(messageTextField)
        self.view.addSubview(separatorContainerView)
    }
    
    func setUpViews(){
    
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        sendButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 8).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        separatorContainerView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        separatorContainerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        separatorContainerView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor).isActive = true
        separatorContainerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func sendMessage(){
        
        let databaseRef = FIRDatabase.database().reference().child("message")
        let time = NSNumber(value: Int(Date().timeIntervalSince1970))
        let value = ["text": messageTextField.text! as AnyObject, "toId": user?.id as AnyObject, "fromId":FIRAuth.auth()?.currentUser?.uid as AnyObject, "time": time]
        databaseRef.childByAutoId().updateChildValues(value)
        messageTextField.text = ""
        
        //print(messageTextField.text!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
