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
//import Result

public typealias URLRequestConvertible = Alamofire.URLRequestConvertible
public typealias Request = Alamofire.Request
public typealias Result = BrightFutures.Result


/**
*
*/
public final class API {

    private var execQueue: [Request] = []

    public init() {

    }

    public func request<T: RequestToken>(token: T) -> Future<T.Response> {
        return self.request(token, builder: Alamofire.request)
    }

    public func request<T: RequestToken>(token: T, builder: URLRequestConvertible -> Request) -> Future<T.Response> {
        let promise = Promise<T.Response>()

        let URLRequest = token.URLRequest
        let request = builder(URLRequest)
        self.execQueue.append(request)

        request.NicoKit_requestToken = token

        request.response { [weak self] (URLRequest, response, data, error) -> Void in

            if let s = self {
                s.execQueue = s.execQueue.filter({ $0 !== request })
            }

            if let data = data as? NSData {
                let serialized = T.transform(URLRequest, response: response, data: data)
                switch serialized {
                case let .Success(box):
                    promise.success(box.value)
                case let .Failure(error):
                    promise.failure(error)
                }
                return
            }


            promise.failure(error ?? NSError())
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

    var URLRequest: NSURLRequest { get }

    static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, data: NSData) -> Result<Response>
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
