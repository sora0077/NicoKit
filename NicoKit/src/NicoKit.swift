//
//  NicoKit.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/03.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

public typealias Method = Alamofire.Method
public typealias Encoding = Alamofire.ParameterEncoding
public typealias Request = Alamofire.Request
public typealias Result = BrightFutures.Result


extension Result {
    
    init(error: NSError) {
        self = .Failure(error)
    }
}

public enum ResponseEncoding {
    
    case Data
    case String(NSStringEncoding?)
    case JSON(NSJSONReadingOptions)
    case Custom(Request.Serializer)
    
    var serializer: Request.Serializer {
        switch self {
        case .Data:
            return Request.responseDataSerializer()
        case let .String(encoding):
            return Request.stringResponseSerializer(encoding: encoding)
        case let .JSON(options):
            return Request.JSONResponseSerializer(options: options)
        case let .Custom(serializer):
            return serializer
        }
    }
}

/**
*
*/
public final class API {

    private var execQueue: [Request] = []
    private let manager: Alamofire.Manager

    public init(configuration: NSURLSessionConfiguration = .defaultSessionConfiguration()) {
        
        self.manager = Manager.sharedInstance
    }
    
    public func request<T: RequestToken>(token: T) -> Future<T.Response> {
        let promise = Promise<T.Response>()

        let method = token.method
        let URLRequest = token.URL
        let parameters = token.parameters
        let encoding = token.encoding
        let serializer = token.resonseEncoding.serializer
        
        let request = manager.request(method, URLRequest, parameters: parameters, encoding: encoding)
        self.execQueue.append(request)

        request.NicoKit_requestToken = token
        
        request.validate().response(serializer: serializer) { [weak self] (URLRequest, response, object, error) -> Void in
            
            if let s = self {
                s.execQueue = s.execQueue.filter({ $0 !== request })
            }
            
            if let error = error {
                promise.failure(error)
                return
            }
            
            let serialized = T.transform(URLRequest, response: response, object: object as! T.SerializedType)
            switch serialized {
            case let .Success(box):
                promise.success(box.value)
            case let .Failure(error):
                promise.failure(error)
            }
        }

        return promise.future
    }

    public func cancel<T: RequestToken>(clazz: T.Type, f: T -> Bool = { _ in true }) {

        for request in self.execQueue {
            if let token = request.NicoKit_requestToken as? T where f(token) {
                request.cancel()
            }
        }
    }
}

/**
*  各APIを表現するためのプロトコル定義
*/
public protocol RequestToken: class {

    typealias Response
    typealias SerializedType

    var method: Method { get }
    var URL: String { get }
    var parameters: [String: AnyObject]? { get }
    var encoding: Encoding { get }
    
    var resonseEncoding: ResponseEncoding { get }
    
    static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response>
}

private var AlamofireRequest_NicoKit_requestToken: UInt8 = 0
private extension Alamofire.Request {


    private var NicoKit_requestToken: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AlamofireRequest_NicoKit_requestToken)
        }
        set {
            objc_setAssociatedObject(self, &AlamofireRequest_NicoKit_requestToken, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

}
