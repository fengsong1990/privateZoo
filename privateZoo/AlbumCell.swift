//
//  AlbumCell.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/16.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet weak var albumNameLab: UILabel!
    @IBOutlet weak var albumImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
