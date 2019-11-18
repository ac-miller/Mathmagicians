//
//  BeastieBackpackCell.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 11/17/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit

class BeastieBackpackCell: UITableViewCell {

    @IBOutlet var beastieName: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var contentContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentContainer.layer.cornerRadius = contentContainer.frame.size.height / 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
