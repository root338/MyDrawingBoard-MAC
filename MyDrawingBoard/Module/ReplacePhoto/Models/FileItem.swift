//
//  FileItem.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation

struct PhotoFileItem {
    let filePath : URL
    let format : String
    let pixelSize : NSSize
}

struct FileItem {
    let filePath: URL
    let isAvailable: Bool
}
