//
//  GetRanking.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/07.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit
import Ono

public class GetRanking {
    
    public enum Target: String {
        case View = "view"
        case Res = "res"
        case Mylist = "mylist"
    }
 
    public enum Period: String {
        case Hourly = "hourly"
        case Daily = "daily"
        case Weekly = "weekly"
        case Monthly = "monthly"
    }
    
    public enum Category: String {
        case All = "all"
        case Music = "music"
        case Ent = "ent"
        case Anime = "anime"
        case Game = "game"
        case Animal = "animal"
        case Science = "science"
        case Other = "other"
    }
    
    public let target: Target
    public let period: Period
    public let category: Category
    
    public init(target: Target = .View, period: Period, category: Category = .All) {
        self.target = target
        self.period = period
        self.category = category
    }
}

extension GetRanking: RequestToken {
    
    public typealias Response = ([Video])
    public typealias SerializedType = ONOXMLDocument
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var URL: String {
        return "http://www.nicovideo.jp/ranking/\(target.rawValue)/\(period.rawValue)/\(category.rawValue)?rss=2.0"
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
        return .Custom({ URLRequest, response, data in
            var error: NSError?
            let xml = ONOXMLDocument(data: data, error: &error)
            if let e = error {
                return (nil, e)
            }
            
            return (xml, nil)
        })
    }

}

extension GetRanking {
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        let xml = object
        
        var values: [Video] = []
        
        let v = NSFastGenerator(xml.XPath("//item"))
        while let v = v.next() as? ONOXMLElement {
            let id = v.firstChildWithTag("link").stringValue().componentsSeparatedByString("/").last!
            let title = v.firstChildWithTag("title").stringValue().componentsSeparatedByString("：")[1]
            let html_description = v.firstChildWithTag("description").stringValue()
            
            let html = ONOXMLDocument.HTMLDocumentWithString(html_description, encoding: NSUTF8StringEncoding, error: nil)
            let description = html.firstChildWithCSS("p.nico-description").stringValue()
            let thumbnail_url = html.firstChildWithCSS("img")["src"] as! String
            
            values.append(Video(
                id: id,
                title: title,
                description: description)
            )
        }
        return Result((values))
    }
}

extension GetRanking {
    
    public struct Video {
        
        public let id: String
        public let title: String
        public let description: String
    }
}
