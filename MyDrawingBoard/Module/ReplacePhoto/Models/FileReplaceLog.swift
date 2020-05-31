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
}

struct FileReplaceLogSet {
    private lazy var log = [FileReplaceResult]()
    
    mutating func add(log: FileReplaceResult) -> FileReplaceResult {
        self.log.append(log)
        return log
    }
}
