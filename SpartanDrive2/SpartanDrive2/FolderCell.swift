//
//  FileCell.swift
//  SpartanDrive2
//
//  Created by Student on 12/3/16.
//  Copyright © 2016 duy nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FolderCell:UITableViewCell{

    var folderName: String = ""
    var folderPath: String = ""
    var seguePath: String = ""
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var folderImage: UILabel!
    
    
    
}
