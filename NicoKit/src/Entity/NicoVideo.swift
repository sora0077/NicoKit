//
//  NicoVideo.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation

public struct NicoVideo {
    
    public let id: String
    public let user_id: Int
    public let title: String
    public let description: String
    public let thumbnail_url: String
    
    public let length_seconds: Int
    
    public let view_counter: Int
    public let mylist_counter: Int
    public let comment_counter: Int
    
    public let tags: [String]
}

extension NicoVideo: DebugPrintable {
    
    public var debugDescription: String {
        let d = [
            "id": id,
            "user_id": user_id,
            "title": title,
            "description": description,
            "thumbnail_url": thumbnail_url,
            "view_counter": view_counter,
            "mylist_counter": mylist_counter,
            "comment_counter": comment_counter,
            "tags": tags
        ]
        return d.description
    }
}

