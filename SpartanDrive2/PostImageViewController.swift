//
//  PostImageViewController.swift
//  SpartanDrive2
//
//  Created by duy nguyen on 11/22/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
class PostImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageName: UITextField!
    @IBOutlet weak var imagedisplay: UIImageView!
    private var imagename : NSString!
    
    
    let databaseref = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    let user = FIRAuth.auth()?.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self,action:#selector(browserImageHandler))
    
        view.addGestureRecognizer(tap)
        //load_img_URLS()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func uploadImage(_ sender: Any) {
        
        if imageName.text! != nil {
            upload()
        }
        else {
            //error message
            print("There is no name!")
        }
        
    }
        
    private func upload(){
       
        
        
        let userref = filePath
        let imagesRef = self.storageref.child("myimage")
        
        if let user = FIRAuth.auth()?.currentUser{
            print("user uid")
            print(user.uid)
            let uploadRef = imagesRef.child("\(user.email!)/\(imagename!).png")
            if let uploadData = UIImagePNGRepresentation(imagedisplay.image!){
                uploadRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                    if (error != nil){
                        print(error)
                    }
                    print("upload successfully")
                    //let imageURLs = userref.child(user.uid).child("IMG_URLS")
                    
                    //let values = ["\(self.imageName!.text!)" : metadata!.downloadURLs![0].absoluteString] as [String : Any]
                    trueArray[self.imageName.text!] = metadata!.downloadURLs![0].absoluteString as String
                    userref?.updateChildValues(trueArray,withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        
                        print("Saved urls to database")
                        MainMenuViewController().refreshControl?.beginRefreshing()
                        self.handleSuccessUpload()
                    })
                    print(metadata!.downloadURLs![0])
                })
            }
        }
        
        
        //        let userref = self.databaseref.child("users")
        //        let imagesRef = self.storageref.child("myimage")
        //        if imageName.text! != nil
        //        {
        //            imagename = imageName.text! as NSString!
        //        }
        //        else{
        //            imagename = "default"
        //        }
        //        if let user = FIRAuth.auth()?.currentUser{
        //            print("user uid")
        //            print(user.uid)
        //            let uploadRef = imagesRef.child("\(user.email!)/\(imagename!).png")
        //            if let uploadData = UIImagePNGRepresentation(imagedisplay.image!){
        //                uploadRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
        //                    if (error != nil){
        //                        print(error)
        //                    }
        //                    print("upload successfully")
        //                    let imageURLs = userref.child(user.uid).child("IMG_URLS")
        //                    let values = ["\(self.imagename!)" : metadata!.downloadURLs![0].absoluteString] as [String : Any]
        //                    imageURLs.updateChildValues(values,withCompletionBlock: { (err, ref) in
        //                        if err != nil {
        //                            print(err)
        //                            return
        //                        }
        //
        //                        print("Saved urls to database")
        //                        self.handleSuccessUpload()
        //                        
        //                    })
        //                    
        //                    print(metadata!.downloadURLs![0])
        //                })
        //            }
        //        }

    }
    
    
    private func handleSuccessUpload(){
        
            performSegue(withIdentifier: "UploadGood", sender: self)
    }
    
    func browserImageHandler(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagedisplay.image = image
        } else{
            print("Something went wrong")
        }
        let path = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (path.lastPathComponent! as NSString!) != nil{
            imagename = (path.lastPathComponent! as NSString!)
            print(imagename)
        }
        
        self.dismiss(animated: true, completion: nil)
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
