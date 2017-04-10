//
//  LoginController+Handler.swift
//  GamesOfChats
//
//  Created by Luiz Alfredo Diniz Hammerli on 02/04/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleSelectProfileImageView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
        
            profileImageView.image = originalImage as? UIImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        
        if(loginRegisterSegmentedControl.selectedSegmentIndex == 0){
            
            guard let email = emailTextField.text , let password = passwordTextField.text else{
                
                print("Form is not valid ")
                return
            }
            
            loginUser(with: email, password: password)
            
        }else{
            
            guard let email = emailTextField.text , let password = passwordTextField.text, let name = nameTextField.text else{
                
                print("Form is not valid")
                return
            }
        
            loginActivityIndicator.startAnimating()
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion:{ (user: FIRUser?, error) in
                
                if (error != nil){
                    
                    print ("erro")
                    return
                }
                
                guard let uid = user?.uid else{
                    return
                }
                
                let imageName = UUID().uuid
                
                let storeRef = FIRStorage.storage().reference().child("\(imageName).jpg")
                
                if let profileImage = self.profileImageView.image, let uploadImage = UIImageJPEGRepresentation(profileImage, 0.2){
                    
                    storeRef.put(uploadImage, metadata: nil, completion: {(metadata, error) in
                    
                        if error != nil{
                            print("error")
                            return
                        }
                        
                        let values = ["name": name, "email": email, "image": metadata?.downloadURL()?.absoluteString]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String: AnyObject])
                    })
                }
            })
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values:[String: AnyObject]){
    
            let dateBaseRef = FIRDatabase.database().reference(fromURL: "https://gameofchats-194ce.firebaseio.com/")
            
            let child = dateBaseRef.child("users").child((uid))
            
            child.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if (err != nil){
                    
                    print("Erro")
                    return
                }
            })
    }
}
