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

    //example of cells being produced
    let exampleArray = ["folder", "image", "folder", "text", "image", "image", "text"]
    var trueArray = [String:String]()
    
    //references
    let databaseref = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    let user = FIRAuth.auth()?.currentUser
    
    //options for top right button
    let options = ["New Folder", "New Image", "New Text", "Share..."]
    
    //the UITableViewCells
    @IBOutlet weak var folderCell: FolderCell!
    @IBOutlet weak var imageCell: ImageCell!
    @IBOutlet weak var textCell: TextCell!
    
    //BackButton functionality
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        var nilString: String? = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nextFilePath
        
        self.fillTrueArrayWithDatabaseNames(theGetData: dataFromDatabase)
        
        tableView.register(FolderCell.self, forCellReuseIdentifier: "folderCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(TextCell.self, forCellReuseIdentifier: "textCell")
        
//        folderCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapFolderCell:")))
//        imageCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapImageCell:")))
//        textCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapTextCell:")))
        
        //loadBasedOnFileDirectory()
        //print("getting from firebase")
        //getInfoFromFirebase(folderPath: filePath)
        print(dataFromDatabase!)
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trueArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if trueArray["f" + String(indexPath.row)] != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapFolderCell"))
            tap.numberOfTapsRequired = 1
            
            let aFolderCell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath as IndexPath) as! FolderCell
        
            aFolderCell.mainMenuViewController = self
            aFolderCell.folderNameLabel.text! = trueArray["f" + String(indexPath.row)]!
            aFolderCell.addGestureRecognizer(tap)
            
            return aFolderCell
        }
        
        else if trueArray["i" + String(indexPath.row)] != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapImageCell"))
            tap.numberOfTapsRequired = 1
            
            let anImageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath as IndexPath) as! ImageCell
            
            anImageCell.mainMenuViewController = self
            anImageCell.imageNameLabel.text! = trueArray["i" + String(indexPath.row)]!
            anImageCell.addGestureRecognizer(tap)
            
            return anImageCell
        }
        
        else {
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapTextCell"))
            tap.numberOfTapsRequired = 1
            
            let aTextCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath as     IndexPath) as! TextCell
            aTextCell.mainMenuViewController = self
            aTextCell.textNameLabel.text! = trueArray["t" + String(indexPath.row)]!
            aTextCell.addGestureRecognizer(tap)
            
            return aTextCell
        }

    }
    
    func fillTrueArrayWithDatabaseNames(theGetData: NSDictionary) {
        
        trueArray = [:]
        var indexCount: Int = 0
        
        for key in theGetData {
            
            if key.value is String {
                
                if key.key as? String != "dummy" {
                    
                    if (key.value as? String)!.characters.first != "i" {
                        
                        //text case
                        print("t" + String(indexCount))
                        trueArray["t" + String(indexCount)] = key.key as? String
                        indexCount += 1
                    }
                    
                    else{
                        
                        //image case
                        print("i" + String(indexCount))
                        trueArray["i" + String(indexCount)] = key.key as? String
                        indexCount += 1
                        
                    }

                }
                    
                else{
                    //dummy data case
                }
                
            }
                
            else {
                
                //folder case
                print("f" + String(indexCount))
                trueArray["f" + String(indexCount)] = key.key as? String
                indexCount += 1
            }
            
        }
        
        print(trueArray)
        
    }
    
    func loadBasedOnFileDirectory(path: FIRDatabaseReference, info: NSDictionary?) {
        
    }

    func tapFolderCell() {
        print("folder")
    }
    
    func tapImageCell() {
        print("image")
    }

    func tapTextCell() {
        print("text")
    }
    
    func deleteCell(cell: UITableViewCell){
        
        if let deletetionIndexPath = tableView.indexPath(for: cell) {
            //items.removeAtIndex(deletionIndexPath.row)
            //tableView.deleteRows(at: deletetionIndexPath, with: .automatic)
        }

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
