//
//  WaterFlowLayout.swift
//  FactoryKit
//
//  Created by itsnow on 16/12/20.
//  Copyright © 2016年 itsnow. All rights reserved.
//

import UIKit

class WaterFlowLayout: UICollectionViewFlowLayout {

    /** 存放所有cell的布局属性 */
   private var attrsArray = [UICollectionViewLayoutAttributes]()
    /** collection滚动高度 */
   private var maxHeight : CGFloat = 0
    /** 当前高度 */
   private var sectionHeight : CGFloat = 0
    /** 当前最大y */
   private var maxSectionHeight : CGFloat = 0
    
    var defaultColumnMargin : CGFloat = 3
    var defaultRowMargin : CGFloat = 3
    var defaultEdgeInsets : UIEdgeInsets = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3)
    var defaultColumnCount : CGFloat = 3
    var defaultHeight : CGFloat = 100
    
    //MARK:-初始化
    override func prepare() {
        super.prepare()
        
        attrsArray.removeAll()
        maxHeight = 0
        maxSectionHeight = 0
        sectionHeight = 0
        
        for i in 0..<collectionView!.numberOfSections {
            let count = collectionView!.numberOfItems(inSection: i)
            for j in 0..<count {
                let indexPath = IndexPath.init(row: j, section: i)
                //获取indexPath对应的布局属性
                let attrs = layoutAttributesForItem(at: indexPath)!
                attrsArray.append(attrs)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
//        var rArray = [UICollectionViewLayoutAttributes]()
//        for cacahAttr in attrsArray {
//            if rect.intersects(cacahAttr.frame) {
//                rArray.append(cacahAttr)
//            }
//        }
//        return rArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        let collectionViewW = collectionView!.frame.size.width
        var w = (collectionViewW - defaultEdgeInsets.left - defaultEdgeInsets.right - (defaultColumnCount - 1)*defaultColumnMargin)/defaultColumnCount
        var h = 2*w
        var x = defaultEdgeInsets.left
        var y = defaultEdgeInsets.top
        //12个为一个周期 根据周期计算位置
        let section = CGFloat(indexPath.row / 6)
        let row = CGFloat(indexPath.row % 6)
        let section2 = indexPath.row / 6
        let row2 = indexPath.row % 6
       
        switch row2 {
        case 0,1,2:
            y = section * (3.0 * (h + defaultRowMargin)) + defaultEdgeInsets.top
            x = defaultEdgeInsets.left + row * (w + defaultColumnMargin)
        case 3:
            if (section2 % 2 == 0){
                y = (3 * section + 1) * (h + defaultRowMargin) + defaultEdgeInsets.top
            }else{
                y = (3 * section + 1) * (h + defaultRowMargin) + defaultEdgeInsets.top
                w = w * 2 + defaultColumnMargin;
                h = h * 2 + defaultRowMargin;
            }
        case 4:
            if (section2 % 2 == 0){
                y = (3 * section + 2) * (h + defaultRowMargin) + defaultEdgeInsets.top;
            }else{
                x = defaultEdgeInsets.left + 2 * (w + defaultColumnMargin);
                y = (3 * section + 1) * (h + defaultRowMargin) + defaultEdgeInsets.top;
            }
        default:
            if (section2 % 2 == 0){
                x = defaultEdgeInsets.left + w + defaultColumnMargin;
                y = (3 * section + 1) * (h + defaultRowMargin) + defaultEdgeInsets.top;
                w = w * 2 + defaultColumnMargin;
                h = h * 2 + defaultRowMargin;
            }else{
                x = defaultEdgeInsets.left + 2 * (w + defaultColumnMargin);
                y = (3 * section + 2) * (h + defaultRowMargin) + defaultEdgeInsets.top;
            }
        }
        
        
        //printLog(message: "maxSectionHeight==\(maxSectionHeight) maxHeight=\(maxHeight)")
        //设置布局属性的frame
        y = y + sectionHeight
        attributes.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
        //解决最后一块小于前一块的问题
        if (maxSectionHeight < y + h) {
            maxSectionHeight = y + h;
        }
        //下一组时 更新高度
        if indexPath.row == collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
            sectionHeight = maxHeight + defaultEdgeInsets.bottom
        }
        //获得最底部位置
        maxHeight = maxSectionHeight + defaultEdgeInsets.bottom
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize{
       return CGSize.init(width: 0, height: maxHeight)
    }
    

}



