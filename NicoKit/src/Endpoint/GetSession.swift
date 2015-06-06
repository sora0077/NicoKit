//
//  GetSession.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit

public class GetSession {
    
    public let mailaddress: String
    public let password: String
    
    public init(mailaddress: String, password: String) {
        self.mailaddress = mailaddress
        self.password = password
    }
}

extension GetSession: RequestToken {
    
    public typealias Response = Session
    public typealias SerializedType = NSData
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var URL: String {
        return "https://secure.nicovideo.jp/secure/login?site=niconico"
    }
    
    public var headers: [String: AnyObject]? {
        return nil
    }
    
    public var parameters: [String: AnyObject]? {
        return [
            "mail": mailaddress,
            "password": password
        ]
    }
    
    public var encoding: RequestEncoding {
        return .URL
    }
    
    public var resonseEncoding: ResponseEncoding {
        return .Data
    }
}

extension GetSession {
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        var dict: [String: (value: String, date: NSDate)] = [:]
        for c in storage.cookiesForURL(request.URL!) as! [NSHTTPCookie] {
            
            dict[c.name] = (value: c.value!, date: c.expiresDate)
        }
        
        var nicohistory = dict["nicohistory"]
        if let n = nicohistory {
            nicohistory?.value = n.value.stringByRemovingPercentEncoding!
        }
        let session = Session(
            user_session: dict["user_session"]!,
            nicosid: dict["nicosid"]!,
            nicohistory: dict["nicohistory"]
        )
        
        return Result(session)
    }
}
