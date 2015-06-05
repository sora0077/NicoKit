//
//  Search.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/04.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import Alamofire

public class Search {
    
    let query: Query
    
    public init(query: Query) {
        self.query = query
    }
}

extension Search: RequestToken {

    public typealias Response = (NSData)
    
    public struct Meta {
        
    }
    
    
    public var URLRequest: NSURLRequest {
        
        let url = "http://api.search.nicovideo.jp/api/snapshot/"
        let URL = NSURL(string: url)!
        let URLRequest = NSURLRequest(URL: URL)
        let encoding = Alamofire.ParameterEncoding.JSON
        
        return encoding.encode(URLRequest, parameters: query.toParameters()).0
    }
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, data: NSData) -> Result<Response> {
        
        println(response)
        
        return Result(data)
        
//        if let str = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
//            return (str, Meta())
//        }
//        return ("", Meta())
    }
    
}

public extension Search {
    
    public class Query {
        
        public enum Order: String {
            case Desc = "desc"
            case Asc = "asc"
        }
        
        public enum SortBy: String {
            case LastCommentTime = "last_comment_time"
            case ViewCounter = "view_counter"
            case StartTime = "start_time"
            case MylistCounter = "mylist_counter"
            case CommentCounter = "comment_counter"
            case LengthSeconds = "length_seconds"
        }
        
        public enum SearchType {
            
            case Keyword(String)
            case Tag(String)
            
            func toParameters() -> (String, [String]) {
                switch self {
                case let .Keyword(q):
                    return (q, ["title", "description", "tags"])
                case let .Tag(q):
                    return (q, ["tags_exact"])
                }
            }
        }
        
        public let query: String
        public let search: [String]
        public let service: [String] = ["video"]
        public var filters: [Filter] = []
        public var sort_by: SortBy = .LastCommentTime
        public var order: Order = .Desc
        public var from: Int = 0
        public var size: Int = 100
        
        public let issuer: String = ""//NicoKit.appName
        
        public init(type: SearchType) {
            
            let r = type.toParameters()
            self.query = r.0
            self.search = r.1
        }
        
        public func addFilter<F: Filter>(filter: F, _ block: (F -> Void)? = nil) {
            block?(filter)
            self.filters.append(filter)
        }
        
        public func addRangeFilter(#field: String, _ block: RangeFilter -> Void) {
            let filter = RangeFilter(field: field)
            self.addFilter(filter, block)
        }
        
        public func addEqualFilter(#field: String, value: AnyObject) {
            let filter =  EqualFilter(field: field, value: value)
            self.addFilter(filter)
        }
    }
}

extension Search.Query {
    
    func toParameters() -> [String: AnyObject]? {
        
        return [
            "query": self.query,
            "search": self.search,
            "service": self.service,
            "odrder": self.order.rawValue,
            "sort_by": self.sort_by.rawValue,
            "from": self.from,
            "size": self.size,
            "issuer": self.issuer,
            "filters": self.filters.map { $0.toParameters() },
            "join": [
                "cmsid",
                "title",
                "description",
                "tags",
                "start_time",
                "thumbnail_url",
                "movie_type",
                "comment_counter",
                "mylist_counter",
                "view_counter",
                "last_res_body",
                "length_seconds",
            ]
        ]
    }
    
    public class Filter {
        
        public let type: String
        public let field: String
        
        init(type: String, field: String) {
            
            self.type = type
            self.field = field
        }
        
        private func toParameters() -> [String: AnyObject]! {
            return nil
        }
    }
    
    public class RangeFilter: Filter {
        
        
        public var from: AnyObject?
        public var to: AnyObject?
        
        public var include_lower: Bool = true
        public var include_upper: Bool = true
        
        public init(field: String) {
            
            super.init(type: "range", field: field)
        }
        
        private override func toParameters() -> [String : AnyObject]! {
            
            var params: [String: AnyObject] = [
                "type": self.type,
                "field": self.field,
                "include_lower": self.include_lower,
                "include_upper": self.include_upper,
            ]
            
            if self.from is NSDate || self.to is NSDate {
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let from = self.from as? NSDate {
                    params["from"] = formatter.stringFromDate(from)
                }
                if let to = self.to as? NSDate {
                    params["to"] = formatter.stringFromDate(to)
                }
            } else {
                if let from: AnyObject = self.from {
                    params["from"] = from
                }
                if let to: AnyObject = self.to {
                    params["to"] = to
                }
            }
            
            return params
        }
    }
    
    public class EqualFilter: Filter {
        
        public let value: AnyObject
        
        public init(field: String, value: AnyObject) {
            
            self.value = value
            super.init(type: "equal", field: field)
        }
        
        private override func toParameters() -> [String : AnyObject]! {
            
            return [
                "type": self.type,
                "field": self.field,
                "value": self.value
            ]
        }
    }
}
