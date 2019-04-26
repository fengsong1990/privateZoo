//
//  WaterCell.swift
//  ShareSecret
//
//  Created by itsnow on 17/6/2.
//  Copyright © 2017年 fengsong. All rights reserved.
//

import UIKit
import Kingfisher
class WaterCell: UICollectionViewCell {

    
    @IBOutlet weak var _bottomTitleLab: UILabel!
    @IBOutlet weak var _bottomView: UIView!
    @IBOutlet weak var _imgV: UIImageView!
    
    var placeholderImage : UIImage?
    
    
    func refreshUI(girlModel : GirlListModel) {
        
        let url = URL.init(string: girlModel.image_thumb)
        _imgV.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        _bottomTitleLab.text = girlModel.content
        _bottomView.isHidden = false
        _bottomTitleLab.isHidden = false
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        _bottomView.isHidden = true
        _bottomTitleLab.isHidden = true
    }

}
