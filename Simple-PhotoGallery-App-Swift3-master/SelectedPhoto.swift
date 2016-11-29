//
//  SelectedPhoto.swift
//  AssignmentP3_DiWu
//
//  Created by WuDi on 2016-10-17.
//  Copyright © 2016 WuDi. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import Firebase

class SelectedPhoto: UIViewController {
    // MARK: Variables and outlets
    //var assetCollection: PHAssetCollection!
    var index: Int = 0
    var photos: PHFetchResult<PHAsset>!
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: Custom methods
    @IBAction func trashButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Delete", message: "Delete This Image?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete From Local", style: .default,
            handler: {(alertAction) in
                self.removePhoto(alert: alert)
            })
        )
        
        alert.addAction(UIAlertAction(title: "Also Delete On Cload", style: .default,
            handler: {(alertAction) in
                // Delete photo on Cloud
                let itemID: String = self.removeSpecialCharsFromString(text: self.photos[self.index].localIdentifier)
                
                self.databaseRef.child(FIRAuth.auth()!.currentUser!.uid).child(itemID).removeValue()
                self.storageRef.child(FIRAuth.auth()!.currentUser!.uid + "/\(itemID).jpg").delete(completion: {(error) -> Void in
                    
                    if error != nil {
                        print("Error deleting file in Storage: \(error)")
                    }
                })

                self.removePhoto(alert: alert)
            })
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel,
            handler: {(alertAction)in
                //Do not delete the photo
                alert.dismiss(animated: true, completion: nil)
            })
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayPhoto() {
        let photoInstance: PHAsset = self.photos[self.index] as PHAsset
        
        PHImageManager.default().requestImage(for: photoInstance, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFit, options: nil,
            resultHandler: {(result, info) -> Void in
                self.selectedImage.image = result
            }
        )
        
        let ratio = Double(photoInstance.pixelWidth) / Double(photoInstance.pixelHeight)
        let width = self.view.bounds.width
        let height = CGFloat(Double(self.view.bounds.width) / ratio)
        let photoSize = CGSize(width: width, height: height)
        let verticalStart = CGFloat((self.view.bounds.height / 2) - (height / 2))
        let startPointImg = CGPoint(x: 0, y: verticalStart)
        let startPointLabel = CGPoint(x: 0, y: verticalStart + height + 10)
        
        self.selectedImage.frame = CGRect(origin: startPointImg, size: photoSize)
        self.locationLabel.frame = CGRect(origin: startPointLabel, size: self.locationLabel.frame.size)
        
        if let location: CLLocation = photoInstance.location {
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            self.locationLabel.text = (String(format: "%.4f", longitude) + ", " + String(format: "%.4f", latitude))
        }
    }
    
    func removePhoto(alert: UIAlertController) {
        PHPhotoLibrary.shared().performChanges({
                //Delete photo locally
                PHAssetChangeRequest.deleteAssets([self.photos[self.index]] as NSArray)
            },
            completionHandler: {(success, error) -> Void in
                alert.dismiss(animated: true, completion: nil)
                
                if success {
                    // Move to the main thread to execute
                    DispatchQueue.main.async(execute: {
                        self.photos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil) as PHFetchResult<PHAsset>
                        
                        if self.photos.count == 0 {
                            print("No Images Left!!")
                            
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            if self.index == self.photos.count {
                                // If we are at the end of array, must step back to prevent out of bound error
                                self.index = self.photos.count - 1
                            }
                            
                            self.displayPhoto()
                        }
                    })
                } else {
                    print("Error: \(error)")
                }
            }
        )
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let validChars: Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        
        return String(text.characters.filter{validChars.contains($0)})
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storageRef = FIRStorage.storage().reference()
        self.databaseRef = FIRDatabase.database().reference()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        self.displayPhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
