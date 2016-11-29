//
//  ThumbNail.swift
//  AssignmentP3_DiWu
//
//  Created by WuDi on 2016-10-18.
//  Copyright © 2016 WuDi. All rights reserved.
//

import UIKit
import CoreLocation

class ThumbNail: UICollectionViewCell {
    // MARK: Variables and outlets
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var locationLabelSmall: UILabel!
    
    // MARK: Custom methods
    func setThumbNail(thumbNailImage: UIImage) {
        self.thumbNail.image = thumbNailImage
    }
    
    func setLocationLabel(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        self.locationLabelSmall.text = (String(format: "%.4f", longitude) + ", " + String(format: "%.4f", latitude))
    }
}
