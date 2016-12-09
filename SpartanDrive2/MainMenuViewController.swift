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
    @IBAction func actionsheet(_ sender: UIBarButtonItem) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share Pressed!")
            //implement sharing code here
            
        })
        let uploadImage = UIAlertAction(title: "Upload Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("upImage pressed!")
            self.performSegue(withIdentifier: "PostImage", sender: self)
            //implement whatever here
        })
        let uploadText = UIAlertAction(title: "Upload Text", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("upText pressed!")
            //implement whatever here
        })
        let makeFolder = UIAlertAction(title: "Make Folder", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("mkdir pressed!")
            //implement whatever here
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(shareAction)
        optionMenu.addAction(uploadImage)
        optionMenu.addAction(uploadText)
        optionMenu.addAction(makeFolder)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //BackButton functionality
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        var nilString: String? = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDidAppear(true)
        
        navigationItem.title = nextFilePath
        
        self.fillTrueArrayWithDatabaseNames(theGetData: dataFromDatabase)
        
        tableView.register(FolderCell.self, forCellReuseIdentifier: "folderCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(TextCell.self, forCellReuseIdentifier: "textCell")
        
        print(dataFromDatabase!)
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trueArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if trueArray["f" + String(indexPath.row)] != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFolderCell(sender:)))
            tap.numberOfTapsRequired = 1
            
            let aFolderCell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath as IndexPath) as! FolderCell
            
            aFolderCell.id = trueArray["f" + String(indexPath.row)]!
        
            aFolderCell.mainMenuViewController = self
            aFolderCell.folderNameLabel.text! = trueArray["f" + String(indexPath.row)]!
            aFolderCell.addGestureRecognizer(tap)
            
            return aFolderCell
        }
        
        else if trueArray["i" + String(indexPath.row)] != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapImageCell(sender:)))
            tap.numberOfTapsRequired = 1
            
            let anImageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath as IndexPath) as! ImageCell
            
            anImageCell.id = trueArray["i" + String(indexPath.row)]!
            
            anImageCell.mainMenuViewController = self
            anImageCell.imageNameLabel.text! = trueArray["i" + String(indexPath.row)]!
            anImageCell.addGestureRecognizer(tap)
            
            return anImageCell
        }
        
        else {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTextCell(sender:)))
            tap.numberOfTapsRequired = 1
            
            let aTextCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath as     IndexPath) as! TextCell
            
            aTextCell.id = trueArray["t" + String(indexPath.row)]!
            
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
                    
                    if getHttpsFromImages(firstFiveLetters:(key.value as? String)!) != "https" {
                        
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

    func tapFolderCell(sender: UIGestureRecognizer) {

        let cell = processCell(sender: sender) as? FolderCell
        print("the cell id: ")
        print((cell?.id)!)
    }
    
    func tapImageCell(sender: UIGestureRecognizer) {
        let cell = processCell(sender: sender) as? ImageCell
        print("image id: ")
        print ((cell?.id)!)
        
    }

    func tapTextCell(sender: UIGestureRecognizer) {
        let cell = processCell(sender: sender) as? TextCell
        print("text id: ")
        print((cell?.id)!)
    }
    
    func processCell(sender: UIGestureRecognizer) -> UITableViewCell {
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.location(in: self.tableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        //we could even get the cell from the index, too
        return self.tableView.cellForRow(at: indexPath!)!
    }
    
    
    func deleteCell(cell: UITableViewCell){
        
        if let deletionIndexPath = tableView.indexPath(for: cell) {
           // trueArray.re.removeAtIndex(deletionIndexPath.row)
           // tableView.deleteRows(at: deletionIndexPath, with: .automatic)
        }

    }

    
    func clickOnItem(anyCell: Any?) {
        nextFilePath = (anyCell! as AnyObject).name
        filePath = filePath.child(nextFilePath)
    }
    
    func getHttpsFromImages(firstFiveLetters: String) -> String {
        let b = firstFiveLetters.characters
        let c = b.index(b.startIndex, offsetBy: 0)..<b.index(b.startIndex, offsetBy: 5)
        let substring = firstFiveLetters[c]
        return substring
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
    
    
    //    func createCell() -> UITableViewCell {
    //        return
    //    }
    //
    //    func folderCellCreate() -> FolderCell {
    //
    //    }
    //
    //    func imageCellCreate() -> ImageCell {
    //
    //    }
    //
    //    func textCellCreate() -> TextCell {
    //        
    //    }

    
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
