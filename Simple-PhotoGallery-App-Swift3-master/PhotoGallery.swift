//
//  PhotoGallery.swift
//  AssignmentP3_DiWu
//
//  Created by WuDi on 2016-10-17.
//  Copyright © 2016 WuDi. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

// MARK: Global variables
//let storageFolder: String = "AssignmentP3_Album"
let reusableCellID = "thumbNailCell"

class PhotoGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    // MARK: Variables and outlets
    //var storageFolderFound: Bool = false
    //var assetCollection: PHAssetCollection!
    var photos: PHFetchResult<PHAsset>!
    let locationManager = CLLocationManager()
    var photoLocation: CLLocation?
    var photoIdentifier: String = ""
    var identifierArray = [String]()
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    //var DBQuery: FIRDatabaseQuery?
    //var DBSnapshot: FIRDataSnapshot?
    @IBOutlet weak var thumbNailCollectionView: UICollectionView!

    // MARK: Custom methods
    @IBAction func cameraButton(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // Ask for authorization for using location service while in use
            locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            // Load the camera
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            // No camera available
            let alert = UIAlertController(title: "Error", message: "No Camera Available", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default,
                handler: {(alertAction) -> Void in
                    alert.dismiss(animated: true, completion: nil)
                }
            ))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func syncButtoon(_ sender: AnyObject) {
        // Reminder of SYNC process
        let syncAlert = UIAlertController(title: "Synchronizing", message: "Connecting To Cloud", preferredStyle: .alert)

        self.present(syncAlert, animated: true, completion: nil)
        
        // Query Firebase DB
        let DBQuery: FIRDatabaseQuery? = self.databaseRef.child(FIRAuth.auth()!.currentUser!.uid).queryOrderedByKey() as FIRDatabaseQuery
        
        if DBQuery != nil {
            // Get a snapshot of query result to read the content
            DBQuery!.observeSingleEvent(of: .value, with: {(snapshot) in
                let DBSnapshot: FIRDataSnapshot? = snapshot
                
                var countFileMissing: Int = 0
                let value = DBSnapshot?.value as? NSDictionary
                
                if value != nil {
                    // If Firebase DB query is not empty, we have to compare every entry in the DB with
                    // self.photos(PHAsset we fetched in viewWillAppear).localIdentifier to determine which photos are missing
                    if self.photos != nil {
                        // Extract local identifiers and put them in self.identifierArray
                        var counter = self.photos.count
                        
                        print("\(counter) photos")
                        
                        while counter > 0 {
                            self.identifierArray += [self.removeSpecialCharsFromString(text: self.photos[counter - 1].localIdentifier)]
                            counter -= 1
                        }
                        
                        //print("self.identifierArray: \(self.identifierArray)")
                    }
                    
                    for imgdic in value! {
                        
                        if !self.identifierArray.contains(imgdic.key as! String) {
                            // Find a missing file
                            print("Find a missing file")
                            countFileMissing += 1
                            
                            // Delete previous database key because it has changed and no longer useful
                            self.databaseRef.child(FIRAuth.auth()!.currentUser!.uid).child(imgdic.key as! String).removeValue()
                            
                            if let imgUrl = (imgdic.value as! NSDictionary)["imageUrl"] as? String {
                                let url = NSURL(string: imgUrl)
                                let request = NSURLRequest(url: url as! URL)
                                let config = URLSessionConfiguration.default
                                let session = URLSession(configuration: config)
                                
                                session.dataTask(with: request as URLRequest,
                                    completionHandler: {(data, response, error) -> Void in
                                                    
                                        if error != nil {
                                            print("Error: \(error)")
                                            
                                            return
                                        }
                                        
                                        let image = UIImage(data: data!)
                                        
                                        PHPhotoLibrary.shared().performChanges({
                                                let changeAsset = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                                                
                                                if let assetPlaceholder = changeAsset.placeholderForCreatedAsset {
                                                    self.photoIdentifier = assetPlaceholder.localIdentifier
                                                    
                                                    print("New photo local identifier in SYNC: \(self.photoIdentifier)")
                                                    
                                                    // Register new key
                                                    let storageID = self.removeSpecialCharsFromString(text: self.photoIdentifier)
                                                    let values = ["imageUrl": imgUrl]
                                                    
                                                    print("SYNC storageID: \(storageID)")
                                                    
                                                    self.registerDatabase(id: storageID, url: values as [String: AnyObject])
                                                }
                                            },
                                            completionHandler: {(success, error) in
                                            }
                                        )
                                    }
                                ).resume()
                            }
                        }
                    }
                } else {
                    print("Nothing to sync")
                    
                    syncAlert.title = "Error"
                    syncAlert.message = "No Photo On Cloud"
                }
                
                sleep(1) // Some little trick lol
                
                if countFileMissing != 0 {
                    syncAlert.message = "Restored \(countFileMissing) Photos From Cloud"
                    syncAlert.addAction(UIAlertAction(title: "Okay", style: .default,
                        handler: {(alertAction) -> Void in
                            syncAlert.dismiss(animated: true, completion: nil)
                            
                            // Refresh cells and clear self.identifierArray
                            self.identifierArray.removeAll()
                            self.viewWillAppear(true)
                        }
                    ))
                } else {
                    if syncAlert.message != "No Photo On Cloud" {
                        syncAlert.message = "No Photo Is Missing"
                    }
                    
                    syncAlert.addAction(UIAlertAction(title: "Okay", style: .default,
                        handler: {(alertAction) -> Void in
                            syncAlert.dismiss(animated: true, completion: nil)
                            
                            // Clear self.identifierArray
                            self.identifierArray.removeAll()
                        }
                    ))
                }
            }){(error) in
                print("Error: \(error.localizedDescription)")
                
                syncAlert.title = "Error"
                syncAlert.message = "Unexpected Error"
                syncAlert.addAction(UIAlertAction(title: "Okay", style: .default,
                    handler: {(alertAction) -> Void in
                        syncAlert.dismiss(animated: true, completion: nil)
                    }
                ))
            }
        } else {
            print("Failed to query")
            
            syncAlert.title = "Error"
            syncAlert.message = "Failed Connect To Firebase"
            syncAlert.addAction(UIAlertAction(title: "Okay", style: .default,
                handler: {(alertAction) -> Void in
                    syncAlert.dismiss(animated: true, completion: nil)
                }
            ))
        }
//==================================== If no network connection, will be stuck in UIAlertController
    }
    
    func registerDatabase(id: String, url: [String: AnyObject]) {
        // Create a database reference
        let userRef = self.databaseRef.child(FIRAuth.auth()!.currentUser!.uid).child(id)
        
        userRef.updateChildValues(url) {(error, ref) in
            
            if error != nil{
                print("Error registering Firebase database: \(error)")
                
                return
            }
            
            print("Successfully stored in DB")
        }
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let validChars: Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        
        return String(text.characters.filter{validChars.contains($0)})
    }

    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Firebase
        self.storageRef = FIRStorage.storage().reference()
        self.databaseRef = FIRDatabase.database().reference()

        // Sign in anonymously
        if FIRAuth.auth()?.currentUser == nil {
            FIRAuth.auth()?.signInAnonymously(completion: {(user, error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Authentication success")
                }
            })
        }
        
        // Initialize location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        /*
        // Check storage path, create new folder if necessary
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", storageFolder) // Restrict fetched folder name
        
        let photoAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions) // photoAlbum is the fetched result
        
        if photoAlbum.firstObject != nil {
            // Storage folder is found
            print("Storage folder is found")
            
            self.storageFolderFound = true
            self.assetCollection = photoAlbum.firstObject! as PHAssetCollection
        } else {
            print("Storage folder is NOT found")
            
            // Create storage folder
            var folderPlaceHolder: PHObjectPlaceholder!
            
            PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: storageFolder)
                    folderPlaceHolder = request.placeholderForCreatedAssetCollection
                },
                completionHandler: {(success, error) -> Void in
         
                    if success {
                        self.storageFolderFound = true
                        
                        let createdAlbum = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [folderPlaceHolder.localIdentifier], options: nil)
                        
                        self.assetCollection = createdAlbum.firstObject
                    } else {
                        print("Failed to create album")
                    }
                }
            )
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
        self.navigationItem.title = "No Photos"
        
        /*
        if self.assetCollection != nil {
            // Load photos from assetCollection
            self.photos = PHAsset.fetchAssets(in: self.assetCollection, options: nil) as PHFetchResult<PHAsset>
 
            let photoCount = self.photos.count
 
            if photoCount == 0 {
                self.navigationItem.title = "No Photos"
            } else {
                self.navigationItem.title = "\(photoCount) Photos"
            }
        }*/
        
        // Load photos from camera roll
        self.photos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil) as PHFetchResult<PHAsset>
        
        let photoCount = self.photos.count
        
        if photoCount == 0 {
            self.navigationItem.title = "No Photos"
        } else {
            self.navigationItem.title = "\(photoCount) Photos"
        }
        
        self.thumbNailCollectionView.reloadData()
        
        //print("photoIdentifier: \(self.photoIdentifier)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFullSizePhoto" {
            
            let controller: SelectedPhoto = segue.destination as! SelectedPhoto
            let cell = sender as! ThumbNail
            let indexPath: IndexPath = self.thumbNailCollectionView.indexPath(for: cell)!
            
            //controller.assetCollection = self.assetCollection
            controller.index = indexPath.item
            controller.photos = self.photos
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource methods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.photos != nil {
            return self.photos.count
        }
        
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create reusable cells for displaying photos
        let photoCell: ThumbNail = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellID, for: indexPath) as! ThumbNail
        
        if self.photos.count != 0 {
            // Set thumbnail for cell
            let photoInstance: PHAsset = self.photos[indexPath.item] as PHAsset
            
            if photoInstance.location != nil {
                photoCell.setLocationLabel(location: photoInstance.location!)
            } else {
                photoCell.locationLabelSmall.text = "Location Not Available"
            }
            
            let targetSize = CGSize(width: photoCell.bounds.width * 2, height: photoCell.bounds.height * 2)
            let options = PHImageRequestOptions()
            
            options.resizeMode = PHImageRequestOptionsResizeMode.exact
            
            PHImageManager.default().requestImage(for: photoInstance, targetSize: targetSize, contentMode: .aspectFit, options: options,
                resultHandler: {(result, info) -> Void in
                    photoCell.setThumbNail(thumbNailImage: result!)
                }
            )
        }
        
        return photoCell
    }

    // MARK: UIImagePickerControllerDelegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                // Create asset for the taken image and save it
                PHPhotoLibrary.shared().performChanges({
                        let assetToCreate = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    
                        assetToCreate.location = self.photoLocation // Adding geotag
                    
                        // Clean used geo tag
                        self.photoLocation = nil
                        self.locationManager.stopUpdatingLocation()

                        if let assetPlaceholder = assetToCreate.placeholderForCreatedAsset {
                            self.photoIdentifier = assetPlaceholder.localIdentifier // Retrive the local identifier of the photo
                            //print("PickerController photo local identifier: \(self.photoIdentifier)")
                            
                            /*
                            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection, assets: self.photos) {
                                albumChangeRequest.addAssets([assetPlaceholder] as NSArray!)
                            }*/
                        }
                    },
                    completionHandler: {(success, error) -> Void in
                        // Upload the taken photo to Firebase database
                        let storageID = self.removeSpecialCharsFromString(text: self.photoIdentifier)
                        let storeName: String = FIRAuth.auth()!.currentUser!.uid + "/\(storageID).jpg"
                        let metadata = FIRStorageMetadata()
                        
                        print("StorageID: \(storageID)")
                        print("StoreName: \(storeName)")
                        
                        metadata.contentType = "image/jpeg"
                        
                        if let uploadImage = UIImageJPEGRepresentation(image, 0.4) {
                            self.storageRef.child(storeName).put(uploadImage, metadata: metadata, completion: {(metadata, error) -> Void in
                                
                                if error != nil {
                                    print("Error: \(error)")
                                    
                                    return
                                }
                                
                                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                    let values = ["imageUrl": imageUrl]
                                    
                                    self.registerDatabase(id: storageID, url: values as [String: AnyObject])
                                }
                            })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            picker.dismiss(animated: true, completion: nil)
                        })
                    }
                )
            })
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Clean used geo tag
        self.photoLocation = nil
        self.locationManager.stopUpdatingLocation()
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: CLLocationManagerDelegate methods
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorized, .authorizedWhenInUse:
            //self.locationManager.startUpdatingLocation()

            print("Authorized to use location service")
        default:
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Location Manager Error", message: "Access Denied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default,
            handler: {(alertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
        ))

        self.present(alert, animated: true, completion: nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update current location if possible
        if let currLocation = locations.last {
            if currLocation.horizontalAccuracy < 0 {
                // Invalid accuracy
                print("Invalid accuracy")
                
                return
            }
            
            self.photoLocation = currLocation
            
            //print("longitude: \(currLocation.coordinate.longitude), latitude: \(currLocation.coordinate.latitude)")
        }
    }
}

