//
//  Flv.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation

public struct Flv {
    
    public let thread_id: String
    public let url: String
    public let ms: String
    public let ms_sub: String?
    public let user_id: Int
    public let is_premium: Int
    public let nickname: String
    public let time: Int
    public let done: Bool
    public let l: String?
    public let hms: String?
    public let hmsp: String?
    public let hmst: String?
    public let hmstk: String?
}

extension Flv: DebugPrintable {
    
    public var debugDescription: String {
        let d = [
            "thread_id": thread_id,
            "url": url,
            "ms": ms,
            "ms_sub": ms_sub ?? "nil",
            "user_id": user_id,
            "is_premium": is_premium,
            "nickname": nickname,
            "time": time,
            "done": done,
            "l": l ?? "nil",
            "hms": hms ?? "nil",
            "hmsp": hmsp ?? "nil",
            "hmst": hmst ?? "nil",
            "hmstk": hmstk ?? "nil",
        ]
        return d.description
    }
}

