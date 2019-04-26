//
//  FS_API.swift
//  privateZoo
//
//  Created by fengsong on 2019/4/23.
//  Copyright © 2019 fengsong. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

struct FS_API{

    static let shareManager : FS_API = FS_API()
    
    static let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<UApi>.RequestResultClosure) -> Void in
        if var urlRequest = try? endpoint.urlRequest() {
            urlRequest.timeoutInterval = 20
            closure(.success(urlRequest))
        } else {
            closure(.failure(MoyaError.requestMapping(endpoint.url)))
        }
    }
    static let ApiProvider = MoyaProvider<UApi>(requestClosure: timeoutClosure)
    
    static func request(target:UApi,success successCallback: @escaping (JSON) -> Void,error errorCallback: @escaping (Int) -> Void,failure failureCallback: @escaping (MoyaError) -> Void){
        ApiProvider.request(target) { (result) in
            switch result{
            case let .success(response):
                do{
                    let json = try JSON(response.mapJSON())
                   
                    successCallback(json)
                }catch let error{
                    errorCallback((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
    }
    
}

//extension Response {
//    func mapModel<T: SwiftyJSON>(_ type: T.Type) throws -> T {
//        let jsonString = String(data: data, encoding: .utf8)
//        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return model
//    }
//}

enum UApi {
    case girlList(channel:String)//美女列表
    case girlAlbum(jid:String)//美女相册
    
    
    case AA
}

extension UApi: TargetType {
    var baseURL: URL {
        switch self {
        case .girlList(_),.girlAlbum(_):
            return URL.init(string: "http://ziti2.com")!
        default:
            return URL.init(string: "")!
        }
    }
    //http://ziti2.com/meizi/content/public_time_line.php?channel=1&count=60
    var path: String {
        switch self {
        case .girlList(_):
            return "/meizi/content/public_time_line.php"
        case .girlAlbum(_):
            return ""
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        //return .requestPlain
        var parmeters : [String:Any] = [:]
        switch self {
        case .girlList(let channel):
            parmeters["channel"] = channel
            parmeters["count"] = "60"
        default:
            break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
        //return ["Content-Type":"application/json; charset=utf-8"]
    }
    
}

//extension Response {
//    func mapModel<T: SwiftyJSON>(_ type: T.Type) throws -> T {
//        let jsonString = String(data: data, encoding: .utf8)
//        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return model
//    }
//}
//
extension MoyaProvider {

    
    
//    open func request<T: HandyJSON>(_ target: Target,
//                                    model: T.Type,
//                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
//
//        return request(target, completion: { (result) in
//            guard let completion = completion else { return }
//            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
//                completion(nil)
//                return
//            }
//            completion(returnData?.data?.returnData)
//        })
//    }
}
