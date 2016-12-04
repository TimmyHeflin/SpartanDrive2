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

class TextCell:UITableViewCell{
    
    var textName: String = ""
    var textPath: String = ""
    var seguePath: String = ""
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textImage: UILabel!

    
}
