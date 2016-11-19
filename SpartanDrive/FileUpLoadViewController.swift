//
//  FileUploadViewController.swift
//  SpartanDrive
//
//  Created by duy nguyen on 11/17/16.
//  Copyright © 2016 CMPE137. All rights reserved.
//

import UIKit
import Firebase

class FileUploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageToPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func filePicker(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: false, completion: nil)
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image

    }
    
    @IBOutlet weak var uploadImage: UIButton!

    @IBAction func postImage(sender: AnyObject) {
        let uploadData = UIImagePNGRepresentation(self.imageToPost.image!)
        let storageRef = FIRStorage.storage().reference().child("image.png")
        storageRef.putData(uploadData!, metadata: nil, completion:
            {(metadata,error) in
                if error != nil
                {
                    print(error)
                    return
                }
                print(metadata)
                
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
