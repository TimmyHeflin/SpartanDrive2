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
    let user = FIRAuth.auth()?.currentUser
    let options = ["New Folder", "New Image", "New Text", "Share..."]
    
    @IBOutlet weak var folderCell: FolderCell!
    @IBOutlet weak var imageCell: ImageCell!
    @IBOutlet weak var textCell: TextCell!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        var nilString: String? = nil
        
        
    }
    
    //@IBOutlet weak var dropDownOptions: DropMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "stuff"
        
        tableView.register(FolderCell(), forCellReuseIdentifier: "folderCell")
        
        
        
        folderCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
        imageCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
        textCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
        
        
        
        //loadBasedOnFileDirectory()
        print("getting from firebase")
        print(getInfoFromFirebase(folderPath: filePath))
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filePathArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath as IndexPath)
    }
    
    func getInfoFromFirebase(folderPath: FIRDatabaseReference) -> NSDictionary? {
        var theValue: NSDictionary?
        if let user = FIRAuth.auth()?.currentUser{
            if user != nil{
                let urls = folderPath.observeSingleEvent(of: .value, with: { (snapshot) in
                    
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
    
    func loadBasedOnFileDirectory(path: FIRDatabaseReference, info: NSDictionary?) {
        
    }

    func tapRecognized(sender: UITapGestureRecognizer) {
        print("it can see it")
    }
    
    func clickOnFolder(folderCell: FolderCell) {
        nextFilePath = folderCell.folderName
        filePath = filePath.child(nextFilePath)
    }
    
    func clickOnImage(imageCell: ImageCell) {
        nextFilePath = imageCell.imageName
        filePath = filePath.child(nextFilePath)
    }
    
    func clickOnText(textCell: TextCell) {
        nextFilePath = textCell.textName
        filePath = filePath.child(nextFilePath)
    }

    
    
}
