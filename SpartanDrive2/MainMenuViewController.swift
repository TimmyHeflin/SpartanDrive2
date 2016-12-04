//
//  MainMenuViewController.swift
//  SpartanDrive2
//
//  Created by Student on 12/1/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class MainMenuViewController: UITableViewController {

    let databaseref = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    let options = ["New Folder", "New Image", "New Text", "Share..."]
    
    
    //@IBOutlet weak var dropDownOptions: DropMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(getInfoFromFirebase())
        
        
    }
    
    func getInfoFromFirebase() -> NSDictionary? {
        var theValue: NSDictionary?
        if let user = FIRAuth.auth()?.currentUser{
            if user != nil{
                let urls = self.databaseref.child("users").child(user.uid).child("homeFolder").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    if value != nil {
                        //print(snapshot.value as? NSDictionary)
                        theValue = value
                    }
                    else {
                        self.createTheInitialFolder()
                    }

//                    if value != nil {
//                        return value
//                    }

                }) { (error) in
                    print(error.localizedDescription)
                    
                }
            }
        }
        
        return theValue
    }
    
    func createTheInitialFolder() {
        
        let firstFolder:String = "homeFolder"
        let userref = self.databaseref.child("users")
        
        if let user = FIRAuth.auth()?.currentUser {
            let folder = userref.child(user.uid)
            
            folder.child(firstFolder).child("isItShared").setValue(false)
        }
        
        print("here")
        
        
    }

    
    
}
