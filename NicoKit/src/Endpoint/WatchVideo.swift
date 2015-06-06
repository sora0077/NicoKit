//
//  WatchVideo.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit

public class WatchVideo {
    
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension WatchVideo: RequestToken {
    
    public typealias Response = ()
    public typealias SerializedType = NSData
    
    public var method: HTTPMethod {
        return .HEAD
    }
    
    public var URL: String {
        return "http://www.nicovideo.jp/watch/\(id)?watch_harmful=1"
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
        return .Data
    }
}

extension WatchVideo {
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        return Result(())
    }
}
