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
    var types : [photoFormat] = [.png, .jpeg]
    weak var delegate : ReplacePhotoServiceDelegate?
    
    func runReplace() {
        
    }
}

extension ReplacePhotoService {
    func analysisPhoto(path: String?) throws {
        let isDir = try isDirectory(filePath: path)
        if isDir {
            let paths = try FileManager.default.subpathsOfDirectory(atPath: path!)
            for filePath in paths {
                
            }
        }
        
    }
    
    func handle(filePath: String)  {
        
    }
    
    func isDirectory(filePath: String?) throws -> Bool {
        guard filePath == nil else { throw ReplacePhotoError.folderIsEmpty }
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        guard FileManager.default.fileExists(atPath: filePath!, isDirectory: isDirectory) else {
            throw ReplacePhotoError.unavailable
        }
        return isDirectory.pointee.boolValue
    }
}
