//
//  MainVC.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/15.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Photos
class MainVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1 = createNavigationController(vc: FileVC(), title: "资源库", nomalImageName: "", selectImageName: "")
        let nav2 = createNavigationController(vc: GirlVC(), title: "妹子图", nomalImageName: "", selectImageName: "")
        self.viewControllers = [nav1,nav2]
    }
    
    @objc func createNavigationController(vc:UIViewController,title:String,nomalImageName:String,selectImageName:String) -> UINavigationController{
        
        let VC_Nav = BasicNav(rootViewController: vc)
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: nomalImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: selectImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGBA(r: 0, g: 182, b: 255, a: 1)],
                                          for: UIControl.State.selected)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : RGBA(r: 57, g: 57, b: 57, a: 1)],
                                          for: UIControl.State.normal)
        VC_Nav.tabBarItem = tabBarItem
        vc.title = title
        return VC_Nav
        
    }

}

extension MainVC{
    
    static func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return image }
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
}
