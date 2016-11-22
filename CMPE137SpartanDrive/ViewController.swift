//
//  ViewController.swift
//  CMPE137SpartanDrive
//
//  Created by duy nguyen on 11/19/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import FirebaseAuth
import Firebase
class ViewController: UIViewController,GIDSignInUIDelegate{

    @IBOutlet weak var GoogleSignIn: GIDSignInButton!
    @IBOutlet weak var BtnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        GIDSignIn.sharedInstance().uiDelegate = self
        if error != nil {
            print(error)
            return
        }        
        GIDSignIn.sharedInstance().uiDelegate  = self
        setupGoogleButton()
    }
    fileprivate func setupGoogleButton(){
//        let googleBtn = GIDSignInButton()
//        var point: CGPoint = BtnLogin.frame.origin
//        googleBtn.frame = CGRect(x: point.x - (BtnLogin.frame.width / 2), y: point.y + BtnLogin.frame.height + 8, width: BtnLogin.frame.width, height: BtnLogin.frame.height)
//        view.addSubview(googleBtn)
//        googleBtn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
//        
        
        let googleBtn = UIButton()
        let point: CGPoint = BtnLogin.frame.origin
        googleBtn.frame = CGRect(x: point.x - (BtnLogin.frame.width / 2), y: point.y + BtnLogin.frame.height + 8, width: BtnLogin.frame.width, height: BtnLogin.frame.height)
//        googleBtn.backgroundColor = .transparent
        googleBtn.setTitle("Sign In with Google", for: .normal)
        googleBtn.titleLabel?.textColor = .black
//        googleBtn.setImage(#imageLiteral(resourceName: "google.png"), for: .normal)
        googleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        googleBtn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        view.addSubview(googleBtn)
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    func handleSignIn(){
        GIDSignIn.sharedInstance().signIn()
        self.performSegue(withIdentifier: "login_redirect", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

