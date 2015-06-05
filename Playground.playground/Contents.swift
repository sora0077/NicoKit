//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import NicoKit
import LoggingKit

LOGGING_VERBOSE()

var str = "Hello, playgrouna"

let api = API()

let query = Search.Query(type: .Tag("Sims4"))

let search = Search(query: query)

api.request(search).onSuccess { response in
    Logging.d(response.0.first)
}

let aaa = [17]

XCPSetExecutionShouldContinueIndefinitely()
