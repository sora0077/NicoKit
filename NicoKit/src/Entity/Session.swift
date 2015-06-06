//
//  Session.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation

public struct Session {
    
    public let user_session: (value: String, date: NSDate)
    public let nicosid: (value: String, date: NSDate)
    public let nicohistory: (value: String, date: NSDate)?
}

extension Session: DebugPrintable {
    
    public var debugDescription: String {
        let d = [
            "user_session": user_session,
            "nicosid": nicosid,
            "nicohistory": nicohistory
        ]
        return d.description
    }
}
