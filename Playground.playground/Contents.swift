//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import NicoKit
import Ono

ONOXMLElement()



var str = "Hello, playgrouna"

let api = API()

let query = Search.Query(type: .Tag("Sims4"))

let search = Search(query: query)

api.request(search).onSuccess { response in
    println(response)
    if let str = NSString(data: response, encoding: NSUTF8StringEncoding) {
        println(str)
        
    } else {
        println("empty")
    }
}

let aaa = [17]

XCPSetExecutionShouldContinueIndefinitely()
