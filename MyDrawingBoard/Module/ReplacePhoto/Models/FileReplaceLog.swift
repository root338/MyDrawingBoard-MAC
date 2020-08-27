//
//  FileReplaceLog.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/5/30.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

struct FileReplaceResult {
    
    let originItem: PhotoFileItem
    let newItem: PhotoFileItem?
    let error: Error?
    var isSuccess : Bool {
        return error == nil && newItem != nil
    }
}

struct FileReplaceLogSet {
    private lazy var log = [FileReplaceResult]()
    private(set) var totalCount : Int = 0
    private(set) var errorCount: Int = 0
    
    mutating func add(log: FileReplaceResult) -> FileReplaceResult {
        self.log.append(log)
        if !log.isSuccess {
            errorCount += 1
        }
        totalCount += 1
        return log
    }
    
    mutating func clear() {
        totalCount = 0
        errorCount = 0
        log.removeAll()
    }
}
