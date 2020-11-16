//
//  main.swift
//  ReplacePhoneTools
//
//  Created by apple on 2020/9/21.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation
/**
 可处理的参数
 "path" 替换到的路径（目标）
 "replacePath" 从那个路径读取文件 （来源）
 "pathIsDepth" 是否递归读取来源内部目录(默认true)
 "replacePathIsDepth" 是否递归读取目标内部目录（默认false）
 错误提示
 errCode (> 0)   替换错误的个数
 errCode (==0)   没有错误
 errCode (all)   需要替换的资源全部找不到
 errCode (== -1) 需要替换的目录没有符合的资源
 */


let argv = CommandLine.arguments

if argv.count <= 1 {
    print("没有输入参数")
    exit(0)
}
do {
    let info = try handle(params: Array(argv[1..<argv.count]))
    let result = try ReplaceService(info: info).runReplace()
    if let resultMsg = result.msg {
        print(resultMsg)
    }
    exit(0)
} catch let localErr as ReplaceError {
    switch localErr {
    case .err(let msg):
        print(msg)
    }
    exit(1)
} catch {
    print(error.localizedDescription)
    exit(1)
}


