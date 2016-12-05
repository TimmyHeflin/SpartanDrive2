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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        
        return UILabel()
    }()
    
    func setupViews() {
        addSubview(nameLabel)
    }
    
}
