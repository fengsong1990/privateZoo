//
//  PhotoCell.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/16.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImgV: UIImageView!
    @IBOutlet weak var checkSelectBtn: UIButton!
    
    var tapClicked: (() -> Void)?
    var phAsset : PHAsset!
    
    func refreshUI(phAsset :PHAsset) {
        self.phAsset = phAsset
        
        let sharedManager = FS_AssetManager.share
         sharedManager.requestThumbnailImage(for: phAsset, resultHandler: { [unowned self](image, _) in
            self.photoImgV.image = image
            
            let isSelect = sharedManager.getPhotoSelectStaus(phAsset: phAsset)
            if(isSelect){
                self.checkSelectBtn.isSelected = true
                sharedManager.updateSelectPhoto(phAsset: phAsset, isSelect: true)
                self.photoImgV.image = sharedManager.image(byApplyingAlpha: 0.5, image: image)
            }
            
        })
       
        
    }
    
    //点击选择
    @IBAction func checkSelectAction(_ sender: UIButton) {
        
        checkSelectBtn.isSelected = !checkSelectBtn.isSelected
        
        let sharedManager = FS_AssetManager.share
        sharedManager.updateSelectPhoto(phAsset: self.phAsset, isSelect: checkSelectBtn.isSelected)
        
        if(checkSelectBtn.isSelected){
            self.photoImgV.image = sharedManager.image(byApplyingAlpha: 0.5, image: photoImgV.image!)
        }else{
             sharedManager.requestThumbnailImage(for: self.phAsset, resultHandler: {[unowned self] (image, _) in
                self.photoImgV.image = image
            })
        }

        //点击
        if tapClicked != nil {
            tapClicked!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
