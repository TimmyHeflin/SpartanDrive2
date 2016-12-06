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

    let exampleArray = ["folder", "image", "folder", "text", "image", "image", "text"]
    
    
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
        //init(UITableViewStyle())
        
        navigationItem.title = nextFilePath
        
        tableView.register(FolderCell.self, forCellReuseIdentifier: "folderCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(TextCell.self, forCellReuseIdentifier: "textCell")
        
//        folderCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
//        imageCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
//        textCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapRecognized:")))
        
        //loadBasedOnFileDirectory()
        //print("getting from firebase")
        //getInfoFromFirebase(folderPath: filePath)
        print(dataFromDatabase!)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if exampleArray[indexPath.row] == "folder"{
            let aFolderCell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath as IndexPath) as! FolderCell
            aFolderCell.mainMenuViewController = self
            return aFolderCell
        }
        
        else if exampleArray[indexPath.row] == "image"{
            let anImageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath as IndexPath) as! ImageCell
            anImageCell.mainMenuViewController = self
            return anImageCell
        }
        
        else{
            let aTextCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath as IndexPath) as! TextCell
            aTextCell.mainMenuViewController = self
            return aTextCell
        }
        
        
        //return tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath as IndexPath)
    }
    
    
    
    
    func deleteCell(cell: UITableViewCell){
        
        if let deletetionIndexPath = tableView.indexPath(for: cell) {
            //items.removeAtIndex(deletionIndexPath.row)
            //tableView.deleteRows(at: deletetionIndexPath, with: .automatic)
        }
        
        
        
    }
    
    func loadBasedOnFileDirectory(path: FIRDatabaseReference, info: NSDictionary?) {
        
    }

    func tapRecognized(sender: UITapGestureRecognizer) {
        print("it can see it")
    }
    
    func clickOnItem(anyCell: Any?) {
        nextFilePath = (anyCell! as AnyObject).name
        filePath = filePath.child(nextFilePath)
    }
    
    func insert(){
        //append to the main array
        
        //forRow array.count - 1
        //        let insertionIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        //
        //        tableView.insertRows(at: insertionIndexPath, with: UITableViewRowAnimation)
        //
        //        tableView.reloadData()
    }
    
    func insertBatch(){
        //        var indexPaths = [NSIndexPath]()
        //        for i in array.count...array.count + 5 {
        //            array.append("new item")
        //            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        //        }
        //
        //        var bottomHalfIndexPaths = [NSIndexPath]()
        //        for _ in 0...indexPaths.count / 2 - 1 {
        //            bottomHalfIndexPaths.append(indexPaths.removeLast())
        //        }
        //
        //        tableView.beginUpdates()
        //
        //        tableView.insertRows(at: indexPaths, with: .right)
        //        tableView.insertRows(at: indexPaths, with: .left)
        //        
        //        tableView.endUpdates()
    }
    
    
    //    func createTheInitialFolder() {
    //
    //        let firstFolder:String = "homeFolder"
    //        let userref = self.databaseref.child("users")
    //
    //        if let user = FIRAuth.auth()?.currentUser {
    //            let folder = userref.child(user.uid)
    //
    //            folder.child(firstFolder).child("isItShared").setValue(false)
    //        }
    //
    //        print("here")
    //        
    //    }

//    func clickOnImage(imageCell: ImageCell) {
//        nextFilePath = imageCell.imageName
//        filePath = filePath.child(nextFilePath)
//    }
//    
//    func clickOnText(textCell: TextCell) {
//        nextFilePath = textCell.textName
//        filePath = filePath.child(nextFilePath)
//    }

    
}
