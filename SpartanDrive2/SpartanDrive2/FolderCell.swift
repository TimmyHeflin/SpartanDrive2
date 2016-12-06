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
    var folderPath: FIRDatabaseReference = FIRDatabase.database().reference()
    var seguePath: String = ""
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var folderImage: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        folderName = "default"
        
        
        //name.text = folderName
        
        
        //self.addSubview(folderImage)
        //self.addSubview(name)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return UILabel()
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        //addSubview(folderImage)
        //addSubview(name)
    }
    
}
