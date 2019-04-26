//
//  FSPhotoAlbumVC.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/16.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class FSPhotoAlbumVC: BasicVC {

    var phAssetArray : [PHAsset] = []
    let bottomView = FSAlbumBottomView()
    //  完成闭包
    //var sureClicked: ((_ view: UIView, _ selectPhotos: [PHAsset]) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if #available(iOS 11.0, *) {
//            self.photoCollectionView.contentInsetAdjustmentBehavior = .scrollableAxes
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
        
        view.backgroundColor = UIColor.white
        view.addSubview(self.photoCollectionView)
        view.addSubview(bottomView)
        self.bottomView.leftClicked = { [unowned self] in
            
            let previewVC = FSPreviewPhotoAlbum()
            previewVC.phAssetArray = self.phAssetArray
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
        self.bottomView.rightClicked = { [unowned self] in
            
            g_Notification.post(name: NSNotification.Name(rawValue: n_SelectPhoto), object: FS_AssetManager.share.selectPhotoArray, userInfo: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    

    private let cellIdentifier = "photoCell"
    private lazy var photoCollectionView: UICollectionView = {
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 5
        let cellWidth = (ScreenWidth - shape*5)/4
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: shape, left: shape, bottom: shape, right: shape)
        layout.itemSize = CGSize.init(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = shape// 垂直滚动情况下，表示同一行的两个item之间的间距
        layout.minimumLineSpacing = shape// 垂直滚动情况下，表示连续行之间的行间距
        let rect = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-80)
        let tempView = UICollectionView.init(frame: rect, collectionViewLayout: layout)
        tempView.alwaysBounceVertical = true
        tempView.backgroundColor = UIColor.white
        tempView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        //tempView.register(PhotosFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "photosFooterView")
        tempView.dataSource = self
        tempView.delegate = self
        return tempView
    }()

}

extension FSPhotoAlbumVC:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return phAssetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCell
        if indexPath.row < phAssetArray.count {
            let phAsset = phAssetArray[indexPath.row]
            cell.refreshUI(phAsset: phAsset)
            cell.tapClicked = { [unowned self] in
                
                let selectCount = FS_AssetManager.share.selectPhotoArray.count
                if(selectCount > 0){
                    self.bottomView.buttonIsEnabled = true
                    self.bottomView.sureButton.setTitle("完成(\(selectCount))", for: .normal)
                }else{
                    self.bottomView.buttonIsEnabled = false
                    self.bottomView.sureButton.setTitle("完成", for: .normal)
                }
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let previewVC = FSPreviewPhotoAlbum()
        previewVC.phAssetArray = self.phAssetArray
        previewVC.index = indexPath.row
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    //collectionView里某个cell将要消失
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? PhotoCell{
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.checkSelectBtn.isSelected = false
        }
    }
    
}



// 相册底部view
class FSAlbumBottomView: UIView {
    
    lazy var previewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 12, y: 2, width: 60, height: 40))
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("预览", for: .normal)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(previewClick(button:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var sureButton: UIButton = {
        var FSPhotoAlbumSkinColor = UIColor(red: 0, green: 147/255.0, blue: 1, alpha: 1)
        let button = UIButton(frame: CGRect(x: ScreenWidth-12-64, y: 6, width: 64, height: 32))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("完成", for: .normal)
        button.setBackgroundImage(UIImage.init(named: "login_btn_blue_nor"), for: .normal)
        button.setBackgroundImage(UIImage.init(named: "login_bg"), for: .selected)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(sureClick(button:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var leftButtonTitle: String? {
        didSet {
            self.previewButton.setTitle(leftButtonTitle, for: .normal)
        }
    }
    
    var rightButtonTitle: String? {
        didSet {
            self.sureButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    var buttonIsEnabled = false {
        didSet {
            self.previewButton.isEnabled = buttonIsEnabled
            self.sureButton.isEnabled = buttonIsEnabled
        }
    }
    
    // 预览闭包
    var leftClicked: (() -> Void)?
    
    // 完成闭包
    var rightClicked: (() -> Void)?
    //
    
    
    enum FSAlbumBottomViewType {
        case normal, noPreview
    }
    
    convenience init() {
        
        let rect = UIApplication.shared.statusBarFrame
        let FSHomeBarHeight : CGFloat = 34
        var bottomHeight = ScreenHeight-rect.size.height-44-44
        if rect.size.height > 20 {
            bottomHeight = ScreenHeight-rect.size.height-44-44-FSHomeBarHeight
        }
        
        self.init(frame: CGRect(x: 0, y: bottomHeight, width: ScreenWidth, height: 44+FSHomeBarHeight), type: .normal)
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, type: .normal)
    }
    
    init(frame: CGRect, type: FSAlbumBottomViewType) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        if type == .normal {
            self.addSubview(self.previewButton)
        }
        
        self.addSubview(self.sureButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: handle events
    @objc func previewClick(button: UIButton) {
        if leftClicked != nil {
            leftClicked!()
        }
    }
    
    @objc func sureClick(button: UIButton) {
        if rightClicked != nil {
            rightClicked!()
        }
    }
}
