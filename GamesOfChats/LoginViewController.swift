//
//  LoginViewController.swift
//  LoginFirebase
//
//  Created by Luiz Alfredo Diniz Hammerli on 07/03/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFielHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var separatorName:NSLayoutConstraint?
    var messageViewController:ViewController?
    
    let loginActivityIndicator: UIActivityIndicatorView = {
    
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
        
    }()
    
    let inputContainerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
        
    }()
    
    lazy var registerButton: UIButton = {
    
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 88, g: 101, b: 161)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
        
    }()
    
    let nameTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .words
        
        return textField
        
    }()
    
    let emailTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Email Register"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        
        return textField
        
    }()
    
    let passwordTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        
        return textField
        
    }()
    
    let nameSeparatorView: UIView = {
    
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    let emailSeparatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    lazy var profileImageView: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "profile")
        image.contentMode = .scaleAspectFill
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        image.isUserInteractionEnabled = true
        
        return image
        
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {

        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        self.view.addSubview(inputContainerView)
        self.view.addSubview(registerButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(nameSeparatorView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(emailSeparatorView)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(profileImageView)
        self.view.addSubview(loginRegisterSegmentedControl)
        self.view.addSubview(loginActivityIndicator)
        
        setUpInputContainerView()
        setUpProfileImageView()
        setUpSegmentedControl()
        setUpRegisterButton()
        updateInputContainerViewSize()
        setUpLoginActivityIndicatorView()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            self.loginActivityIndicator.stopAnimating()
            
            if FIRAuth.auth()?.currentUser?.uid != nil {
                
                if(self.loginRegisterSegmentedControl.selectedSegmentIndex == 1){
                
                    self.messageViewController?.navigationItem.title = self.nameTextField.text
                }
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    func segmentedControlValueChanged(){
    
        registerButton.setTitle(loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex), for: .normal)
        
        updateInputContainerViewSize()
    }
    
    func loginUser(with email: String, password: String){
    
        loginActivityIndicator.startAnimating()
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            if(error != nil){
            
                self.loginActivityIndicator.stopAnimating()
                print ("Erro")
                return
            }
            
            self.messageViewController?.checkUserData()
        }
    }
    
    //MARK Olar
    func setUpInputContainerView(){
    
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        
        inputContainerViewHeightAnchor?.isActive = true
        
        setUpNameTextField()
        setUpEmailTextField()
        setUpNameSeparatorView()
        setUpEmailSeparatorView()
        setUpPasswordTextView()
    }
    
    func setUpLoginActivityIndicatorView(){
        
        loginActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginActivityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        loginActivityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
    func setUpRegisterButton(){
        
        registerButton.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant:     12).isActive = true
        
        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setUpSegmentedControl(){
    
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setUpProfileImageView(){
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setUpNameTextField(){
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    func setUpEmailTextField(){
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextFielHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFielHeightAnchor?.isActive = true
    }
    
    func setUpPasswordTextView(){
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setUpNameSeparatorView(){
    
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        separatorName = nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        separatorName?.isActive = true

    }
    
    func setUpEmailSeparatorView(){
    
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
    }
    
   func updateInputContainerViewSize(){

        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
    
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        separatorName?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
    
        emailTextFielHeightAnchor?.isActive = false
        emailTextFielHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFielHeightAnchor?.isActive = true
        emailTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "E-mail" : "E-mail Register"
    
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
}

extension UIColor{

    convenience init(r: Float, g: Float, b: Float){
    
        self.init(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
