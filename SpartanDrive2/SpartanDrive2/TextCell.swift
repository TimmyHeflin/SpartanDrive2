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
    var mainMenuViewController: UITableViewController?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //The image of the cell
    let textImageLabel: UILabel = {
        let label = UILabel()
        label.text = "✏️"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //The name of the cell
    let textNameLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //The delete button
    let delButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Setup all the views into subviews with constraints for each
    func setupViews() {
        addSubview(textImageLabel)
        addSubview(textNameLabel)
        addSubview(delButton)
        
        //this is the horizontal constraint for all views
        //withVisualFormat shows their positions in the cell
        //views is the array of views in the cell
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-[v1]-250-[v2]-25-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textImageLabel, "v1": textNameLabel, "v2": delButton]))
        
        //add action
        delButton.addTarget(self, action: "handleAction", for: .touchUpInside)
        
        //this is vertical constraint for the image
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textImageLabel]))
        
        //this is vertical constraint for the text
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textNameLabel]))
        
        //this is vertical constraint for the delete button
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": delButton]))
    }
    
    func handleAction(){
        print("really?")
        //mainMenuViewController?.deleteCell(self)
    }

}
