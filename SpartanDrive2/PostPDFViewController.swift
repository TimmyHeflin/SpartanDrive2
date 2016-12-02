//
//  PostPDFViewController.swift
//  SpartanDrive2
//
//  Created by Student on 11/30/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
class PostPDFViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var pdfNameField: UITextField!
    @IBOutlet weak var imagedisplay: UIImageView!
    private var pdfName : NSString!
    
    
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
        upload()
    }
    
    private func upload(){
        
        
        let userref = self.databaseref.child("users")
        let imagesRef = self.storageref.child("mypdfs")
        if pdfNameField.text! != nil
        {
            pdfName = pdfNameField.text! as NSString!
        }
        else{
            pdfName = "default"
        }
        if let user = FIRAuth.auth()?.currentUser{
            print("user uid")
            print(user.uid)
            let uploadRef = imagesRef.child("\(user.email!)/\(pdfName!).pdf")
            if let uploadData = UIImagePNGRepresentation(imagedisplay.image!){
                uploadRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                    if (error != nil){
                        print(error)
                    }
                    print("upload successfully")
                    let imageURLs = userref.child(user.uid).child("IMG_URLS")
                    let values = ["\(self.pdfName!)" : metadata!.downloadURLs![0].absoluteString] as [String : Any]
                    imageURLs.updateChildValues(values,withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        
                        print("Saved urls to database")
                        self.handleSuccessUpload()
                        
                    })
                    
                    print(metadata!.downloadURLs![0])
                })
            }
        }
        
    }
    
    
    private func handleSuccessUpload(){
        
        performSegue(withIdentifier: "UploadSuccess", sender: self)
    }
    
    func browserImageHandler(){
        let pdfPicker = UIImagePickerController()
        //pdfPicker.delegate = self
        pdfPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(pdfPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pdf = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagedisplay.image = pdf
        let path = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (path.lastPathComponent! as NSString!) != nil{
            pdfName = (path.lastPathComponent! as NSString!)
            print(pdfName)
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
