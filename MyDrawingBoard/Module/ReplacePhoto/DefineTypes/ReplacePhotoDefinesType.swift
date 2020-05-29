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
    case folderIsEmpty
    case unavailable
    case fromPathIsEmpty
    case toPathIsEmpty
    case photoIsEmpty
}

enum photoFormat : String {
    case png = "png"
    case jpeg = "jpeg"
}
