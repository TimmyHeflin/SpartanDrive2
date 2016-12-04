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

class FolderTemplateViewController: UITableViewController {
    
    let databaseref = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    let options = ["New Folder", "New Image", "New Text", "Share..."]
    
    
    //@IBOutlet weak var dropDownOptions: DropMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
}
