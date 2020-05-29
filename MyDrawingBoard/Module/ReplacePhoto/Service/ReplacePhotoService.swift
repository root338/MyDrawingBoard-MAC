//
//  ReplacePhotoService.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/5/25.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

protocol ReplacePhotoServiceDelegate : NSObjectProtocol {
    
}

class ReplacePhotoService: NSObject {
    var fromFolder: String?
    var toFolder: String?
    var types : [String] = ["png", "jpeg"]
    weak var delegate : ReplacePhotoServiceDelegate?
    
    func runReplace() throws {
        guard let fromFolder = self.fromFolder else { throw ReplacePhotoError.toPathIsEmpty }
        guard let toFolder = self.toFolder else { throw ReplacePhotoError.toPathIsEmpty }
        guard let fromFileItems = analysisPhoto(path: fromFolder) else {
            
        }
        guard let toFileItems = analysisPhoto(path: toFolder) else {
            
        }
    }
}

extension ReplacePhotoService {
    /// 分析路径中图片
    func analysisPhoto(path: String, isRecursive: Bool = false) -> [PhotoFileItem]? {
        var fileItems = [PhotoFileItem]()
        FileManager.default.enumerator(at: path, deepRecursion: isRecursive) { (filePath, isDir) -> FileManager.EnumeratorOperate in
            if !isDir, let fileItem = handle(filePath: filePath) {
                fileItems.append(fileItem)
            }
            return .none
        }
        return fileItems
    }
    /// 创建图片对象
    func handle(filePath: String) -> PhotoFileItem? {
        let pathExtension = filePath.ml_pathExtension
        guard types.contains(pathExtension) else {
            return nil
        }
        guard let imagePixelSize = NSImage(contentsOfFile: filePath)?.imagePixelSize else {
            return nil
        }
        return PhotoFileItem(filePath: filePath, format: pathExtension, pixelSize: imagePixelSize)
    }
}
