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
    var mainMenuViewController: UITableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //folderName = "default"
        
        
        //name.text = folderName
        
        
        //self.addSubview(folderImage)
        //self.addSubview(name)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //the image of the cell
    let folderImageLabel: UILabel = {
        let label = UILabel()
        label.text = "🗂"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    //the text of the cell
    let folderNameLabel: UILabel = {
        let label = UILabel()
        label.text = "folder"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //the delete button
    let delButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Setup all the views into subviews with constraints for each
    func setupViews() {
        addSubview(folderImageLabel)
        addSubview(folderNameLabel)
        addSubview(delButton)
        
        //add action
        delButton.addTarget(self, action: "handleAction", for: .touchUpInside)
        
        //this is the horizontal constraint for all views
        //withVisualFormat shows their positions in the cell
        //views is the array of views in the cell
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-[v1]-275-[v2]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": folderImageLabel, "v1": folderNameLabel, "v2": delButton]))
        
        //this is vertical constraint for the image
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": folderImageLabel]))
        
        //this is vertical constraint for the text
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": folderNameLabel]))
        
        //this is vertical constraint for the delete button
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": delButton]))
    }
    
    func handleAction(){
        print("really?")
        //mainMenuViewController?.deleteCell(self)
    }
    
}
