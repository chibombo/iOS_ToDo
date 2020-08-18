//
//  ToDoTableViewCell.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 17/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
            
    
    class var identifer: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifer,
                     bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
