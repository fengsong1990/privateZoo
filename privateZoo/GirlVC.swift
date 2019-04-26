//
//  GirlVC.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/23.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit

class GirlVC: BasicVC {

    var channel : Int = 1
    var girlList : [GirlListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "切换", style: .plain, target: self, action: #selector(GirlVC.changeLibrary))

        getGirlData()
        
        view.backgroundColor = UIColor.white
        view.addSubview(self.collectionView)
    }
    
    lazy var flowLayout1 : XHWaterfallFlowLayout = {
        let flowLayout = XHWaterfallFlowLayout()
        flowLayout.columnCount = 3
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sDelegate = self
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let rect = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tempView = UICollectionView.init(frame: rect, collectionViewLayout: self.flowLayout1)
        tempView.alwaysBounceVertical = true
        tempView.backgroundColor = UIColor.white
        tempView.register(UINib.init(nibName: "WaterCell", bundle: nil), forCellWithReuseIdentifier: "WaterCell")
        tempView.dataSource = self
        tempView.delegate = self
        
        return tempView
    }()

}

extension GirlVC{
    
    @objc func getGirlData() {
    
        FS_API.request(target: .girlList(channel: "\(channel)"), success: { (json) in
            self.girlList = GirlListModel.mapModel(jsonDic: json)
            self.collectionView.reloadData()
            
        }, error: { (error) in
            print("\(error)")
        }) { (moyaError) in
            print("\(moyaError)")
        }
    }
    
   @objc func changeLibrary() {
    
    channel = channel + 1
    if channel > 3 {
        channel = 1
    }
    getGirlData()
    
    }
    
}

extension GirlVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return girlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterCell", for: indexPath) as! WaterCell
        
        if indexPath.row < girlList.count{
            let girlModel = girlList[indexPath.row]
            cell.refreshUI(girlModel: girlModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row < girlList.count{
            let girlModel = girlList[indexPath.row]
            let fileVC = FileVC()
            fileVC.photoArray = girlModel.image_list
            fileVC.webResource = true
            fileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fileVC, animated: true)
        }

    }
    
}


// MARK: -
extension GirlVC : XHWaterfallFlowLayoutDelegate{
    
    func getHeightExceptImage(atIndex indexPath: IndexPath!) -> CGFloat {
        
        return 0
    }
    
    func getImageRatio(ofWidthAndHeight indexPath: IndexPath!) -> CGFloat {
        
        
        return 0.5
    }
}
