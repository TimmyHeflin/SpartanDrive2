//
//  ViewController.swift
//  SpartanDrive
//
//  Created by Student on 11/5/16.
//  Copyright © 2016 CMPE137. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var m_UserEmail: UITextField!
    @IBOutlet weak var m_Password: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBOutlet weak var SignInButton: GIDSignInButton!
  // @IBOutlet weak var signInButton: GIDSignInButton!
    
    /*func signinbutton(sender: GIDSignInButton) {
        sign(<#T##signIn: GIDSignIn!##GIDSignIn!#>, didSignInFor: <#T##GIDGoogleUser!#>, withError: <#T##NSError!#>)
    }*/
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        
        try! FIRAuth.auth()!.signOut()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken((authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user,error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            self.performSegueWithIdentifier("login", sender: self)
        })
    }

    
    @IBAction func signIn(sender: AnyObject) {
        FIRAuth.auth()?.createUserWithEmail(m_UserEmail.text!, password: m_Password.text!, completion: {(user,error) in
        
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print("User Create !")
            }
        })
    }
    
    
    
    
    

}

