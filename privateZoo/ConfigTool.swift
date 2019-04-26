//
//  ConfigTool.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/15.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit

func printLog<T>(message: T,file: String = #file,method: String = #function,line: Int = #line)
{
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}

func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

let g_Notification = NotificationCenter.default
let n_SelectPhoto = "SelectPhoto"


let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

class ConfigTool: NSObject {

    static let shareInstance = ConfigTool()
    
    
    func myAlbumName() -> String{
        
        _ = Bundle.main.infoDictionary
        var appName = Bundle.main.infoDictionary?["CFBundleExecutable"]
        if appName == nil {
            appName = "酷我相册"
        }
        return appName as! String
    }
    
    func myTempFilePath() -> String{
        return "\(ConfigTool.shareInstance.tempUnzipPath()!)/web/私密相册"
    }
    
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path += "/web.zip"
        return path
    }
    
    func tempUnzipPath() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //path += "/web"
        let url = NSURL(fileURLWithPath: path)
        do {
            try  FileManager.default.createDirectory(at: url as URL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        return url.path
    }
    
    func createFileDir(path : String) {
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do{
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                printLog(message: "createFileDir==\(error)")
            }
        }
    }
    
    func getFilePath(fileName : String) -> String {
        
        let filePath = myTempFilePath().appending("\(fileName)")
        return filePath
    }
    
    func getSaveFileName(fileName : String) -> String {
        
        let filePath = getFilePath(fileName: fileName)
        if isExistFilePath(filePath: filePath) {
            return "1_\(fileName)"
        }
        return fileName
    }
    
    func isExistFilePath(filePath : String) -> Bool {
        
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func saveFileToDisk(fileData : NSData , filePath : String){
        
        guard !isExistFilePath(filePath: filePath) else {
            printLog(message: "isExistFilePath")
            return
        }
        DispatchQueue.global().async {
            let write = fileData.write(toFile: filePath, atomically: true)
            DispatchQueue.main.async {
                if write{
                    printLog(message: "data保存成功\(filePath)")
                }
            }
        }
    }
}

//extension ConfigTool : SSZipArchiveDelegate{
//    
//    func unZipFile(){
//        
//        let fileManage = FileManager.default
//        printLog(message: "documents==\(tempZipPath())")
//        if fileManage.fileExists(atPath: tempZipPath()) {
//            let boolV = SSZipArchive.unzipFile(atPath: tempZipPath(), toDestination: tempUnzipPath()! , delegate: self)
//            if boolV {
//                printLog(message: "成功解压")
//                do{
//                    try fileManage.removeItem(atPath: tempZipPath())
//                }catch{
//                }
//            }else{
//                printLog(message: "解压失败")
//            }
//        }else{
//            printLog(message: "解压文件不存在a")
//        }
//    }
//    
//    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: unz_global_info) {
//        printLog(message: "将要解压")
//    }
//    
//    func zipArchiveDidUnzipArchiveAtPath(path: String!, zipInfo: unz_global_info, unzippedPath: String!, withFilePaths filePaths: NSMutableArray!) {
//        printLog(message: "解压完成")
//    }
//    
//}
