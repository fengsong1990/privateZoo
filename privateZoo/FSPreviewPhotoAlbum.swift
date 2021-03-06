//
//  FSPreviewPhotoAlbum.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/17.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class FSPreviewPhotoAlbum: BasicVC {

    var phAssetArray : [PHAsset] = []
    
    var webResource : Bool = false
    var photoArray : [String] = []
    
    //用来放置各个图片单元
    var collectionView:UICollectionView!
    
    //collectionView的布局
    var collectionViewLayout: UICollectionViewFlowLayout!
    //默认显示的图片索引
    var index:Int = 0
    
    
    //初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景设为黑色
        self.view.backgroundColor = UIColor.black
        
        //collectionView尺寸样式设置
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        //横向滚动
        collectionViewLayout.scrollDirection = .horizontal
        
        //collectionView初始化
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.register(PreviewPhotoCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(collectionView)
        
        
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    //视图显示时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //视图消失时
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //将要对子视图布局时调用（横竖屏切换时）
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //重新设置collectionView的尺寸
        collectionView.frame.size = self.view.bounds.size
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//ImagePreviewVC的CollectionView相关协议方法实现
extension FSPreviewPhotoAlbum :UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    //collectionView单元格创建
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! PreviewPhotoCell
            
            if webResource{
                if indexPath.row < photoArray.count {
                    let photoUrlStr = photoArray[indexPath.row]
                    let url = URL.init(string: photoUrlStr)
                    cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
                }
            }
            
            if indexPath.row < phAssetArray.count {
                let phAsset = phAssetArray[indexPath.row]
                cell.refreshUI(phAsset: phAsset)
            }
            return cell
    }
    
    //collectionView单元格数量
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if webResource{
            return photoArray.count
        }
        return phAssetArray.count
    }
    
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? PreviewPhotoCell{
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()
        }
    }
    
}
