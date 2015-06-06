//
//  NicoKit.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/03.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import Foundation
import APIKit

let NicoKitErrorDomain = "jp.sora0077.NicoKit"

public enum ErrorCode: Int {
    
    case ParseError = 100
}

func error(code: ErrorCode, description: String) -> NSError {
    return NSError(
        domain: NicoKitErrorDomain,
        code: code.rawValue,
        userInfo: [
            NSLocalizedDescriptionKey: description
        ]
    )
}
