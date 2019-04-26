//
//  FileVC.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/23.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class FileVC: BasicVC {


    var phAssetArray : [PHAsset] = []
    var webResource : Bool = false
    var photoArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(self.collectionView)
        if webResource{
            
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "相册", style: .plain, target: self, action: #selector(FileVC.connectPhotoLibrary))
            
            g_Notification.addObserver(self, selector: #selector(FileVC.SelectPhotoNotification(_:)), name: NSNotification.Name(rawValue: n_SelectPhoto), object: nil)
            getTableData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        //let rect = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tempView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: WaterFlowLayout())
        tempView.alwaysBounceVertical = true
        tempView.backgroundColor = UIColor.white
        tempView.register(UINib.init(nibName: "WaterCell", bundle: nil), forCellWithReuseIdentifier: "WaterCell")
        tempView.dataSource = self
        tempView.delegate = self

        if #available(iOS 11.0, *) {
            tempView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tempView
    }()
    
    deinit {
        g_Notification.removeObserver(self)
    }

}

extension FileVC{
    
    @objc func connectPhotoLibrary() {
        
        //FS_AssetManager.share.type = SelectType.photo
        let photoAlbumVC = FSPhotoAlbumListVC()
        photoAlbumVC.title = "资源库"
        let VC_Nav = BasicNav(rootViewController: photoAlbumVC)
        self.present(VC_Nav, animated: true, completion: nil)
    }
    
    @objc func SelectPhotoNotification(_ noti : Notification){
        
        getTableData()
        
    }
    
    @objc func getTableData() {
        
        self.phAssetArray.removeAll()
        let selectPhoto = FS_SQLiteManager.shareManager.getData()
        for obj in selectPhoto.enumerated(){
            let photoId = obj.element
          let result = PHAsset.fetchAssets(withLocalIdentifiers: [photoId], options: nil)
            let phAsset = result.firstObject!
            self.phAssetArray.insert(phAsset, at: 0)
            self.collectionView.reloadData()
            printLog(message: "info==\(phAsset.localIdentifier)")
            
        }
        
//        let result = PHAsset.fetchAssets(withLocalIdentifiers: selectPhoto, options: nil)
//        result.enumerateObjects({ (phAsset, index, _) in
//            self.phAssetArray.append(phAsset)
//            self.collectionView.reloadData()
//            printLog(message: "info==\(phAsset.localIdentifier)===\(index)")
//        })
    }
}

extension FileVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if webResource{
            return photoArray.count
        }else{
            return phAssetArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterCell", for: indexPath) as! WaterCell
        
        if webResource{
            if indexPath.row < photoArray.count{
                let photoUrlStr = photoArray[indexPath.row]
                let url = URL.init(string: photoUrlStr)
                cell._imgV.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            }
            
        }else{
            if indexPath.row < phAssetArray.count{
                let phAsset = phAssetArray[indexPath.row]
                 FS_AssetManager.share.requestPreviewImage(for: phAsset, resultHandler: {(image, _) in
                    cell._imgV.image = image
                })
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        

        let previewVC = FSPreviewPhotoAlbum()
        if webResource {
            previewVC.webResource = true
            previewVC.photoArray = self.photoArray
        }else{
            previewVC.phAssetArray = self.phAssetArray
        }
        previewVC.index = indexPath.row
        previewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
}
