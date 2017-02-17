//
//  Cell.swift
//  SerbestKonsol
//
//  Created by Aydın ÜNAL on 17.02.2017.
//  Copyright © 2017 Aydın ÜNAL. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    @IBOutlet weak var label:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellFunc(telefonNo : String){
        label.text = telefonNo
    }
}
