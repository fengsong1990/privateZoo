//
//  FSPhotoAlbumListVC.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/16.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class FSPhotoAlbumListVC: BasicVC {

    var ItemArray : [([PHAsset],PHAssetCollection)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

      ItemArray = FS_AssetManager.share.getAllAlbum()
               
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(FSPhotoAlbumListVC.cancelPhotoLibrary))
        
                if #available(iOS 11.0, *) {
                    self.albumTableView.contentInsetAdjustmentBehavior = .always
                } else {
                    self.automaticallyAdjustsScrollViewInsets = false
                }
        
        view.backgroundColor = UIColor.white
      view.addSubview(self.albumTableView)
    }
    
   @objc func cancelPhotoLibrary() {
        self.dismiss(animated: true, completion: nil)
    }

    private lazy var albumTableView: UITableView = {
        let rect = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tempTableView = UITableView.init(frame: rect, style: .plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        //tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tempTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "cell")
        tempTableView.rowHeight = 61
        tempTableView.tableFooterView = UIView()
        return tempTableView
    }()

}

extension FSPhotoAlbumListVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumCell
        cell.accessoryType = .disclosureIndicator
        if indexPath.row < ItemArray.count {
            let itemData = ItemArray[indexPath.row]
            cell.albumNameLab.text = "\(FS_AssetManager.share.transFormPhotoTitle(englishName: itemData.1.localizedTitle!))(\(itemData.0.count))"
             FS_AssetManager.share.requestThumbnailImage(for: itemData.0.first!, resultHandler: { (image, _) in
                cell.albumImgV.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < ItemArray.count {
            let itemData = ItemArray[indexPath.row]
            let albumVC = FSPhotoAlbumVC()
            albumVC.phAssetArray = itemData.0
            self.navigationController?.pushViewController(albumVC, animated: true)
        }

        
    }
    
}
