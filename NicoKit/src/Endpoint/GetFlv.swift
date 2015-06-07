//
//  GetFlv.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit

public class GetFlv {
    
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension GetFlv: RequestToken {
    
    public typealias Response = Flv
    public typealias SerializedType = String
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var URL: String {
        return "http://www.nicovideo.jp/api/getflv/\(id)"
    }
    
    public var headers: [String: AnyObject]? {
        return nil
    }
    
    public var parameters: [String: AnyObject]? {
        return nil
    }
    
    public var encoding: RequestEncoding {
        return .URL
    }
    
    public var resonseEncoding: ResponseEncoding {
        return .String(NSUTF8StringEncoding)
    }

}

extension GetFlv {
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        var dict: [String: String] = [:]
        let str = object.stringByRemovingPercentEncoding!
        let kvs = split(str, isSeparator: { $0 == "&" })
            .map({
                split($0, maxSplit: 1, isSeparator: { $0 == "=" })
            })
        for kv in kvs {
            dict[kv[0]] = kv[1]
        }
        
        if "1" == dict["closed"] {
            return Result.Failure(error(.ParseError, ""))
        }
        
        if let e = dict["error"] {
            return Result.Failure(error(.ParseError, e))
        }
        
        return Result(Flv.fromGetFlv(dict))
    }
}

extension Flv {
    
    static func fromGetFlv(dict: [String: String]) -> Flv {
        
        return self(
            thread_id: dict["thread_id"]!,
            url: dict["url"]!,
            ms: dict["ms"]!,
            ms_sub: dict["ms_sub"],
            user_id: dict["user_id"]!.toInt()!,
            is_premium: dict["is_premium"]!.toInt()!,
            nickname: dict["nickname"]!,
            time: dict["time"]!.toInt()!,
            done: dict["done"] == "true",
            l: dict["l"],
            hms: dict["hms"],
            hmsp: dict["hmsp"],
            hmst: dict["hmst"],
            hmstk: dict["hmstk"]
        )
    }
    
}
