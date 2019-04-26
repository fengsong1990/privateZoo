//
//  FS_SQLiteManager.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/22.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import FMDB
class FS_SQLiteManager: NSObject {

    static let shareManager : FS_SQLiteManager = FS_SQLiteManager()

    // 数据库名称
    private let dbName = "privateZoo.db"
    
    // 数据库地址
    lazy var dbURL :URL = {
        let fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(dbName)
        return fileURL
    }()
    // FMDatabase对象（用于对数据库进行操作）
    lazy var _db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
    // FMDatabaseQueue对象（用于多线程事务处理）
    lazy var _dbQueue: FMDatabaseQueue? = {
        // 根据路径返回数据库
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()
}

/* photoId : 本地图片标识
 * photoStatus : 图片状态标记 1:新添加
 
 */
extension FS_SQLiteManager{
    
    func createTable() {
        
        let sql = "CREATE TABLE IF NOT EXISTS PrivateZoo('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'photoId' VARCHAR(255) UNIQUE default '','photoStatus' VARCHAR(255) default '0')"
        if _db.open(){
            if _db.executeUpdate(sql, withArgumentsIn: []){
                printLog(message:"创建表成功")
            }else{
                printLog(message:"创建表失败")
            }
        }
        _db.close()
    }
    
    func insertData(localIdentifier:String)  {
        
        let sql = "INSERT INTO PrivateZoo (photoId,photoStatus) VALUES (?,?)"
        if _db.open(){
            if _db.executeUpdate(sql, withArgumentsIn: [localIdentifier,"1"]){
                printLog(message:"插入成功")
            }else{
                printLog(message:"插入失败")
            }
        }
        _db.close()
    }
    
    func deleteData(localIdentifier:String)  {
        
        let sql = "DELETE FROM PrivateZoo WHERE photoId = ?"
        if _db.open(){
            if _db.executeUpdate(sql, withArgumentsIn: [localIdentifier]){
                printLog(message:"删除成功")
            }else{
                printLog(message:"删除失败")
            }
        }
        _db.close()
    }
    
    func updateData(localIdentifier:String)  {
        let sql = "UPDATE PrivateZoo SET photoStatus = ? WHERE photoId = ?"
        if _db.open(){
            if _db.executeUpdate(sql, withArgumentsIn: ["0",localIdentifier]){
                printLog(message:"更新成功")
            }else{
                printLog(message:"更新失败")
            }
        }
        _db.close()
    }
    ///事务
    func updateTransactionData(localIdentifierArray:[String]) {
        
        if let queue = FS_SQLiteManager.shareManager._dbQueue {
            queue.inTransaction({ (db, rollback) in
                do{
                    for i in 0..<localIdentifierArray.count{
                        let photoId = localIdentifierArray[i]
                        let sql = "UPDATE PrivateZoo SET photoStatus = ? WHERE photoId = ?"
                        try db.executeUpdate(sql, values: ["0",photoId])
                    }
                    printLog(message: "批量更新成功")
                }catch{
                    printLog(message:"批量更新失败，进行回滚!")
                    rollback.pointee = true
                }
            })
        }
    }
    
    func isExistData(localIdentifier:String) -> Bool {
        
        var isExit = false
        let sql = "SELECT * FROM PrivateZoo WHERE photoId = ?"
        if _db.open() {
            if let res = _db.executeQuery(sql, withArgumentsIn: [localIdentifier]){
                while res.next() {
                    isExit = true
                    printLog(message:"数据存在")
                }
            }
        }
        _db.close()
        
        return isExit
    }
    
    func getData() -> [String]{
        
        var dataArray : [String] = []
        let sql = "SELECT * FROM PrivateZoo"
        if _db.open() {
            if let res = _db.executeQuery(sql, withArgumentsIn: []){
                while res.next() {
                    let photoId = res.string(forColumn: "photoId")!
                    dataArray.append(photoId)
                }
            }
        }
        _db.close()
        
        return dataArray
    }
    
  
}
