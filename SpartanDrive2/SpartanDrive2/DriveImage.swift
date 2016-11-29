//
//  DriveImage.swift
//  SpartanDrive2
//
//  Created by duy nguyen on 11/25/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorageUI
class ImageDirve{
    fileprivate let databaseref = FIRDatabase.database().reference()
    fileprivate let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    fileprivate let user = FIRAuth.auth()?.currentUser
    init() {
        var imgURLs : String!
        var imagename : String!
        var imageDisplay : UIImage!

    }

    private func load_img_URLS(){
        
        let userref = self.databaseref.child("users").child((user?.uid)!).child("IMG_URLS")
        let imgURL = userref.observeSingleEvent(of: .value, with: { (snapshot) in
            let urls_dict = snapshot.value as! NSDictionary
            print(urls_dict)
        })
        
    }
    
    
    private func downloadimages(){
    
    }
    
    private func downloadAnimage(){
//        FIRStorage.storage().referenceForURL(userPhotoUrl).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
//            dispatch_async(dispatch_get_main_queue()) {
//                myPost.userPhoto = UIImage(data: data!)
//                self.tableView.reloadData()
//            }
//        })
        var imageload : UIImageView!
        imageload.sd_setImage(with: storageref)
    }
    
}
