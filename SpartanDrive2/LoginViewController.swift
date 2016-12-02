//
//  LoginViewController.swift
//  SpartanDrive2
//
//  Created by duy nguyen on 11/22/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class LoginViewController: UIViewController,GIDSignInUIDelegate{

    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    lazy var RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    
//    let nameTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Name"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Sign with Google", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        GIDSignIn.sharedInstance().uiDelegate = self
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(RegisterButton)
        view.addSubview(googleLoginButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupRegisterButton()
        setupGoogleButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
//        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        //need x, y, width, height constraints
//        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
//        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
//        
//        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
//        
//        //need x, y, width, height constraints
//        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
//        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
//        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo:inputsContainerView.topAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    fileprivate func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo:inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupRegisterButton() {
        //need x, y, width, height constraints
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.topAnchor.constraint(equalTo:googleLoginButton.bottomAnchor, constant: 12).isActive = true
        RegisterButton.widthAnchor.constraint(equalTo: googleLoginButton.widthAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleLogin(){
        
        //implement Login here
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            //successfully logged in our user
            self.dismiss(animated: true, completion: nil)
            self.handleSuccessfullSignIn()
        })
    }
    
    private func handleSuccessfullSignIn(){
        performSegue(withIdentifier: "toHomeScreen", sender: self)
        //performSegue(withIdentifier: "TableView", sender: self)
        //performSegue(withIdentifier: "postImage", sender: self)

    }
    
    fileprivate func setupGoogleButtons() {
        //add google sign in button
        //need x, y, width, height constraints
        googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLoginButton.topAnchor.constraint(equalTo:loginButton.bottomAnchor, constant: 12).isActive = true
        googleLoginButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleGoogleSignIn(){
        GIDSignIn.sharedInstance().signIn()
        if let user = FIRAuth.auth()?.currentUser{ // if authenticated
            let userref = FIRDatabase.database().reference().child("users").child(user.uid).child("IMG_URLS")
            print(userref)
            self.handleSuccessfullSignIn()

        } else {
            print("Fail to sign in with google")
        }
     
//        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    @objc private func handleRegister(){
        performSegue(withIdentifier: "RegisterSegue", sender: self)
        

//        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
//            print("Form is not valid")
//            return
//        }
//        
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
//            
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            guard let uid = user?.uid else {
//                return
//            }
//            
//            //successfully authenticated user
//            let ref = FIRDatabase.database().reference(fromURL: "https://spartan-storage.firebaseio.com/")
//            let usersReference = ref.child("users").child(uid)
//            let values = ["name": name, "email": email]
//            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                
//                if err != nil {
//                    print(err)
//                    return
//                }
//                
//                print("Saved user successfully into Firebase db")
//                
//            })
            
//        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
