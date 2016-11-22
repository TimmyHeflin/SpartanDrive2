//
//  PostImageViewController.swift
//  CMPE137SpartanDrive
//
//  Created by duy nguyen on 11/20/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import FirebaseAuth
class PostImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var error: NSError?
    @IBOutlet weak var imageToPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToPost.image = #imageLiteral(resourceName: "upload_defaut_image.jpg")
        

        // Do any additional setup after loading the view.
          let tap = UITapGestureRecognizer(target: self,action:#selector(browserImageHandler))
        
        view.addGestureRecognizer(tap)
        
        let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
        
        let imagesRef = storageref.child("myimage")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var imageBrowser: UITapGestureRecognizer!

  
    
    func browserImageHandler(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagepicker, animated: true, completion: nil)
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageToPost.image = image
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func PostImage(_ sender: Any) {
        
        
        let storageref = FIRStorage.storage().reference().child("myimage/myimage.png")
        if let uploadData = UIImagePNGRepresentation(imageToPost.image!){
            storageref.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if (error != nil){
                    print(error)
                }
                let downloadURL = metadata?.downloadURLs
                let useremail = FIRAuth.auth()?.currentUser?.uid
                let dataref = FIRDatabase.database().reference().child("Users").child("\(useremail)")
                dataref.setValue(["urls": downloadURL])
                print(downloadURL)
            
            })
        }
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
