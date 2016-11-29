//
//  ImageCollectionViewController.swift
//  SpartanDrive2
//
//  Created by duy nguyen on 11/25/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ImageCollectionViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    // collection view cell default width, height
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var imgs = [UIImage]()
    let cellId = "cellId"
    
    let databaseref = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference(forURL: "gs://spartan-storage.appspot.com")
    private var urls = [String]()
    
    
    let uploadBtn = UIBarButtonItem (image: nil, style: .plain, target: self, action: #selector(handleupload))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.backgroundColor = UIColor.white
        
        getUserImage_URLS()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @objc private func handleupload(){
        print("AAAAAAAAA")
        performSegue(withIdentifier: "UploadImage", sender: self)
    }
    
    func getUserImage_URLS(){
        if let user = FIRAuth.auth()?.currentUser{
            if user != nil{
                let urls = self.databaseref.child("users").child(user.uid).child("IMG_URLS").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
//                    print(value)
                    if value != nil {
                    for (key,val) in value! {
//                        print("Key \(key) \nValue \(val)")
//                        self.urls.append(val as! String)
                        if let url = URL(string: val as! String){
                            self.downloadImage(url: url)
//                            self.urls.append(val as! String)
                        }
                    }
                    }
                    print(self.urls)
//                    DispatchQueue.main.async() { () -> Void in
//                        self.collectionView?.reloadData()
//                    }
                }) { (error) in
                    print(error.localizedDescription)
                    
                }
            }
        }
    }

    
    // download Image asynchronously and assign to collection view cell
    func downloadCellPhotoInBackground( imageUrl: NSURL){
        return self.downloadImage(url: imageUrl as URL)
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImage(url: URL) {
        print("Download Started")
        var img : UIImage!
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")

                img = UIImage(data: data)!
                self.imgs.append(img)
            
            DispatchQueue.main.async() { () -> Void in
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgs.count
    }
    @IBAction func upload(_ sender: Any) {
        handleupload()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PhotoCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = UIColor.white
    
        
        //        // set corner radious for image
        //        cell.setPhotoCornerRadious(radious: self.cellWidth/4)
//        let str_url = self.urls[indexPath.row]
        
        
        
//        let im = imgs[indexPath.row]
//        
//        cell.galleryImage = UIImageView(image: im)
//        cell.galleryImage?.image = UIImage(named: im)
//        cell.galleryImage.loadImageUsingCacheWithUrlString(urlString: str_url)
//        if let newimageURL = URL(string : str_url){
////           img = self.downloadImage(url: newimageURL)
//            cell.galleryImage.sd_setImage(with: newimageURL)
//            
//        }
        cell.galleryImage.image = imgs[indexPath.row]
//        cell.galleryImage? = UIImageView(image: imgs[indexPath.row])
//        cell.galleryImage.sd_setImage(with: str_url)
//        if cell.galleryImage != nil{
//            cell.galleryImage!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / CGFloat(4))
    }

}


class PhotoCollectionViewCell: UICollectionViewCell {
    
    var galleryImage: UIImageView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        galleryImage = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width - CGFloat(4), height: frame.size.height - CGFloat(4)))
        galleryImage.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(galleryImage)
    }
    //    // gallery image
//        let  galleryImage: UIImageView = {
//            let imageView = UIImageView()
//            imageView.image = UIImage(named: "upload_default_image")
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            return imageView
//        }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        setupViews()
//        addSubview(galleryImage)
//    }
//
//    func setupViews() {
//        addSubview(galleryImage)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //
    //
    //    let galleryImage: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.layer.cornerRadius = 22
    //        imageView.layer.masksToBounds = true
    //        imageView.contentMode = .scaleAspectFill
    //        return imageView
    //    }()
    //
//        override func setupViews() {
//            addSubview(galleryImage)
//        }
    //    // gallery image
    //@IBOutlet weak var galleryImage: UIImageView!
    
    //    // set image corner radious and border
    //    func setPhotoCornerRadious(radious: Int){
    //        self.galleryImage.layer.cornerRadius = CGFloat(radious)
    //        self.galleryImage.layer.borderWidth = 1
    //    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        //        // Initialization code
//                addSubview(galleryImage)
//    }
    
    //    override init(style: UICollectionViewCell, reuseIdentifier: String?){
    //        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    //
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
}


