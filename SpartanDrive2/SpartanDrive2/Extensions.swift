//
//  DriveImage.swift
//  SpartanDrive2
//
//  Created by duy nguyen on 11/25/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        var imageUrlString: String?
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: (urlString as AnyObject) as! NSString){
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
            let imageToCache = UIImage(data: data!)
                
            if imageUrlString == urlString {
                    self.image = imageToCache
            }
                
            imageCache.setObject(imageToCache!, forKey: urlString as NSString)

//                if let downloadedImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
//                    
//                    self.image = downloadedImage
//                }
            })
            
        }).resume()
    }
    
}
