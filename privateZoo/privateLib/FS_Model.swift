//
//  FS_Model.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/24.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import SwiftyJSON

class FS_Model: NSObject {
    

}

class GirlListModel : NSObject{
    
    var content : String = ""
    var image_list : [String]!
    var image_thumb : String!
    
    static func mapModel(jsonDic : JSON) -> [GirlListModel]{
        
        var array : [GirlListModel] = []
        let jsonArray = jsonDic["feeds"].arrayValue
        for jsonObj in jsonArray{
            let jsonDic = jsonObj.dictionaryValue
            let girlM = GirlListModel()
            girlM.content = jsonDic["content"]!.stringValue
            girlM.image_thumb = jsonDic["image_thumb"]!.stringValue
            girlM.image_list = jsonDic["image_list"]!.arrayValue.map({ (json1) -> String in
                return json1.stringValue
            })
            array.append(girlM)
        }
        return array
    }
}
