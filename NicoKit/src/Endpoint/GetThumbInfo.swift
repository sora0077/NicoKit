//
//  GetThumbInfo.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit
import Ono
import LoggingKit

public class GetThumbInfo {
    
    public let videos: [String]
    
    public init(videos: [String]) {
        self.videos = videos
    }
}

extension GetThumbInfo: RequestToken {
    
    public typealias Response = [NicoVideo]
    public typealias SerializedType = ONOXMLDocument
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var URL: String {
        return "http://i.nicovideo.jp/v3/video.array"
    }
    
    public var headers: [String: AnyObject]? {
        return nil
    }
    
    public var parameters: [String: AnyObject]? {
        return ["v": videos]
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

extension GetThumbInfo {
    
    public static func transform(request: NSURLRequest, response: NSHTTPURLResponse?, object: SerializedType) -> Result<Response> {
        
        let xml = object
        if "ok" == xml.rootElement["status"] as? NSString {
            
            var videos: [NicoVideo] = []
            xml.enumerateElementsWithXPath("//video_info") { video, idx, stop in
                videos.append(NicoVideo.fromXML(video))
            }
            return Result(videos)
        } else {
            
            let description = xml.rootElement.firstChildWithTag("error").firstChildWithTag("description").stringValue()
            
            return Result.Failure(error(.ParseError, description))
        }
    }
}

extension NicoVideo {
    
    static func fromXML(xml: ONOXMLElement) -> NicoVideo {
        
        let video = xml.firstChildWithTag("video")
        
        let id = video.firstChildWithTag("id").stringValue()
        let user_id = video.firstChildWithTag("user_id").numberValue().integerValue
        let title = video.firstChildWithTag("title").stringValue()
        let description = video.firstChildWithTag("description").stringValue()
        let thumbnail_url = video.firstChildWithTag("thumbnail_url").stringValue()
        
        let length_seconds = video.firstChildWithTag("length_in_seconds").numberValue().integerValue
        
        let view_counter = video.firstChildWithTag("view_counter").numberValue().integerValue
        let mylist_counter = video.firstChildWithTag("mylist_counter").numberValue().integerValue
        
        let comment_counter = xml.firstChildWithTag("thread").firstChildWithTag("num_res").numberValue().integerValue
        
        var tags: [String] = []
        let v = NSFastGenerator(xml.XPath("//tags/tag_info/tag"))
        while let v = v.next() as? ONOXMLElement {
            tags.append(v.stringValue())
        }
        
        return self(
            id: id,
            user_id: user_id,
            title: title,
            description: description,
            thumbnail_url: thumbnail_url,
            length_seconds: length_seconds,
            view_counter: view_counter,
            mylist_counter: mylist_counter,
            comment_counter: comment_counter,
            tags: tags
        )
    }
}
