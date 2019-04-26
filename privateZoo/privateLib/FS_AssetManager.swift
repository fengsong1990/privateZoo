//
//  FS_AssetManager.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/16.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos


enum SelectType{
    case photo
    case video
    case all
}

class FS_AssetManager: NSObject {
    //单利
    static let share : FS_AssetManager = FS_AssetManager()
    var selectPhotoArray : [String] = []  ///选中的图片
    var type : SelectType = SelectType.all//选择的类型
    
    
    // MARK: - 获取所有相册信息
    func getAllAlbum() -> [([PHAsset],PHAssetCollection)] {
        
        unowned let weakSelf = self
        var ItemArray : [([PHAsset],PHAssetCollection)] = []
        //系统相册
        let albumRegulars = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        albumRegulars.enumerateObjects { (assetCollection, index, _) in
            // 获取所有相册对象
            let phAssetArray = weakSelf.getAllPhotosAssetInAblumCollection(assetCollection: assetCollection)
//            if (phAssetArray!.count > 0){
//                printLog(message: "\(weakSelf.transFormPhotoTitle(englishName: assetCollection.localizedTitle!))相册==\(phAssetArray!.count)")
//            }else{
//                printLog(message: "\(weakSelf.transFormPhotoTitle(englishName: assetCollection.localizedTitle!))是空相册")
//            }
            if(phAssetArray!.count > 0){
                let assetItem = (phAssetArray!, assetCollection)
                ItemArray.append(assetItem)
            }
        }
        //获取用户自定义相册
        let userLibrary = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
        userLibrary.enumerateObjects { (assetCollection, index, _) in
            // 获取所有相册对象
            let phAssetArray = weakSelf.getAllPhotosAssetInAblumCollection(assetCollection: assetCollection)
            if(phAssetArray!.count > 0){
                let assetItem = (phAssetArray!, assetCollection)
                ItemArray.append(assetItem)
            }
        }
        return ItemArray
    }
    
    // MARK: - 获取相册里的所有图片的PHAsset对象
    func getAllPhotosAssetInAblumCollection(assetCollection:PHAssetCollection) -> [PHAsset]?{
        var phArray : [PHAsset] = []
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: true)]
        //option.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: assetCollection, options: option)
        result.enumerateObjects({ (phAsset, index, _) in
            
            if(self.type == SelectType.photo){
                if phAsset.mediaType == PHAssetMediaType.image{
                    phArray.insert(phAsset, at: 0)
                }
            }else if(self.type == SelectType.video){
                if phAsset.mediaType == PHAssetMediaType.video{
                    phArray.insert(phAsset, at: 0)
                }
            }else{
                phArray.insert(phAsset, at: 0)
            }
        })
        return phArray
    }
    
    // MARK: - 获取缩略图
    @discardableResult
    public func requestThumbnailImage(for asset: PHAsset, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        //        option.resizeMode = .fast
        let targetSize = self.getThumbnailSize(originSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight))
        return PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image: UIImage?, dictionry: Dictionary?) in
            resultHandler(image, dictionry)
        }
    }
    // MARK: - 获取预览图
    @discardableResult
    public func requestPreviewImage(for asset: PHAsset, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
//        option.resizeMode = .exact
//        option.isNetworkAccessAllowed = true
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        
        let targetSize = self.getPriviewSize(originSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight))
        return PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image: UIImage?, dictionry: Dictionary?) in
            resultHandler(image, dictionry)
        }
    }
    
}

extension FS_AssetManager{
    
    func getPhotoSelectStaus(phAsset:PHAsset) -> Bool {
        for selectLocalIdentifier in selectPhotoArray {
            if(phAsset.localIdentifier == selectLocalIdentifier){
                return true
            }
        }
        return false
    }
    
    func updateSelectPhoto(phAsset:PHAsset,isSelect:Bool) {
        
        //printLog(message: "localIdentifier==\(phAsset.localIdentifier))")
        if isSelect {
            if !selectPhotoArray.contains(phAsset.localIdentifier){
                selectPhotoArray.append(phAsset.localIdentifier)
                
                FS_SQLiteManager.shareManager.insertData(localIdentifier: phAsset.localIdentifier)
            }
        }else{
            if selectPhotoArray.contains(phAsset.localIdentifier){
                let firstIndex = selectPhotoArray.firstIndex(of: phAsset.localIdentifier)
                selectPhotoArray.remove(at: firstIndex!)
                
                FS_SQLiteManager.shareManager.deleteData(localIdentifier: phAsset.localIdentifier)
            }
        }
    }
}

extension FS_AssetManager{
    //判断相册名称
    func transFormPhotoTitle(englishName : String) -> String {
        
        switch englishName {
        case "Bursts":
            return "连拍快照"
        case "Recently Added":
            return "最近添加"
        case "Screenshots":
            return "屏幕快照"
        case "Camera Roll":
            return "相机胶卷"
        case "Selfies":
            return "自拍"
        case "My Photo Stream":
            return "我的照片流"
        case "Videos":
            return "视频"
        case "All Photos":
            return "所有照片"
        case "Slo-mo":
            return "慢动作"
        case "Recently Deleted":
            return "最近删除"
        case "Favorites":
            return "个人收藏"
        case "Panoramas":
            return "全景照片"
        case "Hidden":
            return "已隐藏"
        case "Time-lapse":
            return "延时摄影"
        case "Animated":
            return "动图"
        case "Long Exposure":
            return "长曝光"
        case "Portrait":
            return "人像"
        case "Live Photos":
            return "实况照片"
        default:
            return englishName
        }
    }
    //缩略图尺寸
    func getThumbnailSize(originSize: CGSize) -> CGSize {
        let thumbnailWidth: CGFloat = (ScreenWidth - 5 * 5) / 4 * UIScreen.main.scale
        let pixelScale = CGFloat(originSize.width)/CGFloat(originSize.height)
        let thumbnailSize = CGSize(width: thumbnailWidth, height: thumbnailWidth/pixelScale)
        
        return thumbnailSize
    }
    func getPriviewSize(originSize: CGSize) -> CGSize {
        let width = originSize.width
        let height = originSize.height
        let pixelScale = CGFloat(width)/CGFloat(height)
        var targetSize = CGSize()
        if width <= 1280 && height <= 1280 {
            //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            targetSize.width = CGFloat(width)
            targetSize.height = CGFloat(height)
        } else if width > 1280 && height > 1280 {
            //宽以及高均大于1280，但是图片宽高比例大于(小于)2时，则宽或者高取小(大)的等比压缩至1280
            if pixelScale > 2 {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            } else if pixelScale < 0.5 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else if pixelScale > 1 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            }
        } else {
            //b,宽或者高大于1280，但是图片宽度高度比例小于或等于2，则将图片宽或者高取大的等比压缩至1280
            if pixelScale <= 2 && pixelScale > 1 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else if pixelScale > 0.5 && pixelScale <= 1 {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            } else {
                targetSize.width = CGFloat(width)
                targetSize.height = CGFloat(height)
            }
        }
        return targetSize
    }
    //转换图片
    func image(byApplyingAlpha alpha: CGFloat, image: UIImage?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image?.size ?? CGSize.zero, _: false, _: 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -area.size.height)
        ctx!.setBlendMode(CGBlendMode.multiply)
        ctx?.setAlpha(alpha)
        ctx?.draw((image?.cgImage)!, in: area)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

