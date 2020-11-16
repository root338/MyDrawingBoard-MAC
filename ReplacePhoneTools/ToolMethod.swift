//
//  ToolMethod.swift
//  ReplacePhoneTools
//
//  Created by apple on 2020/9/21.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation

func string(_ string: String, separate: String = ":") throws -> (key: String, value: String) {
    guard let range = string.range(of: separate) else {
        throw ReplaceError.err("\(string) 必须存在 \(separate) 分隔")
    }
    let key = String(string.prefix(upTo: range.lowerBound))
    let value = String(string.suffix(from: range.upperBound))
    return (key, value)
}

func handle(params: [String]) throws -> ReplaceInfo {
    var dic = [String:String]()
    for inputValue in params {
        let result = try string(inputValue)
        dic[result.key] = result.value
    }
    let data = try JSONSerialization.data(withJSONObject: dic, options: .sortedKeys)
    let info = try JSONDecoder().decode(ReplaceInfo.self, from: data)
    return info
}
