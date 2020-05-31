//
//  ReplacePhotoDefinesType.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/5/25.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation

enum ReplacePhotoError : Error {
    case cancelSelectFolder
    case isEmpty(_ message: String)
    case unavailable
    /// 没有找到
    case notFind
    /// 操作失败
    case operateFailure(item: FileReplaceResult)
}

enum photoFormat : String {
    case png = "png"
    case jpeg = "jpeg"
}
