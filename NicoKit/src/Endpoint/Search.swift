//
//  Search.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/04.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Search {
    
    let query: Query
    
    public init(query: Query) {
        self.query = query
    }
}

extension Search: RequestToken {

    public typealias Response = ([Video], Status)
    public typealias SerializedType = String
    
    public var method: Method {
        return .POST
    }
    
    public var URL: String {
        return "http://api.search.nicovideo.jp/api/snapshot/"
    }
    
    public var parameters: [String: AnyObject]? {
        return query.toParameters()
    }
    
    public var encoding: Encoding {
        return .JSON
    }
    
    public var resonseEncoding: ResponseEncoding {
        return .String(NSUTF8StringEncoding)
    }
}

extension Search {

    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        let lines = split(object, isSeparator: { $0 == "\n" })
        
        var status: Status!
        var videos: [Video] = []
        
        for l in lines {
            
            if let d = l.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: d)
                
                if json["errid"] != nil {
                    return .Failure(NSError())
                }
                
                if json["endofstream"] == nil {
                    switch json["type"].stringValue {
                    case "hits":
                        for v in json["values"] {
                            videos.append(Video.fromDictionary(v.1))
                        }
                    case "stats":
                        let v = json["values"][0]
                        let service = v["service"].stringValue
                        let total = v["total"].intValue
                        status = Status(service: service, total: total)
                    default:
                        break
                    }
                }
                
            }
        }
        return Result((videos, status))
    }
}

public extension Search {
    
    public struct Status {
        
        public private(set) var service: String
        public private(set) var total: Int
    }
    
    public struct Video {
        
        public private(set) var cmsid: String
        public private(set) var title: String
        public private(set) var description: String
        
        public private(set) var thumbnail_url: String
        public private(set) var movie_type: String
        
        public private(set) var last_res_body: String?
        
        public private(set) var start_time: String
        public private(set) var length_seconds: Int
        public private(set) var tags: [String]
        
        public private(set) var view_counter: Int
        public private(set) var mylist_counter: Int
        public private(set) var comment_counter: Int
        
    }
}

private extension Search.Video {
    
    static func fromDictionary(dict: JSON) -> Search.Video {
        
        let cmsid = dict["cmsid"].stringValue
        let title = dict["title"].stringValue
        let description = dict["description"].stringValue
        let thumbnail_url = dict["thumbnail_url"].stringValue
        let movie_type = dict["movie_type"].stringValue
        let last_res_body = dict["last_res_body"].string
        let tags = dict["tags"].stringValue
        
        let start_time = dict["start_time"].stringValue
        let length_seconds = dict["length_seconds"].intValue
        
        let view_counter = dict["view_counter"].intValue
        let mylist_counter = dict["mylist_counter"].intValue
        let comment_counter = dict["comment_counter"].intValue
        
        return self(
            cmsid: cmsid,
            title: decodeHTMLEntityString(title),
            description: description,
            thumbnail_url: thumbnail_url,
            movie_type: movie_type,
            last_res_body: last_res_body,
            start_time: start_time,
            length_seconds: length_seconds,
            tags: split(tags) { $0 == " " },
            view_counter: view_counter,
            mylist_counter: mylist_counter,
            comment_counter: comment_counter
        )
    }
    
    static func decodeHTMLEntityString(string: String) -> String {
        
        var string = string.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        string = string.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        string = string.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
        string = string.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
        return string
    }
}

extension Search.Video: DebugPrintable {
    
    public var debugDescription: String {
        let d = [
            "cmsid": cmsid,
            "title": title,
            "description": description,
            "thumbnail_url": thumbnail_url,
            "movie_type": movie_type,
            "last_res_body": last_res_body ?? "nil",
            "start_time": start_time,
            "length_seconds": length_seconds,
            "tags": tags,
            "view_counter": view_counter,
            "mylist_counter": mylist_counter,
            "comment_counter": comment_counter,
        ]
        return d.description
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
