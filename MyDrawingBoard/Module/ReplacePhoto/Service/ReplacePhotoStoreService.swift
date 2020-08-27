//
//  ReplacePhotoStoreService.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/6/6.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

protocol ReplacePhotoStoreServiceDelegate : NSObjectProtocol {
    func service(_ service: ReplacePhotoStoreService, didChange selectedURL: URL, identifier: ReplacePhotoPathTypeIdentifier)
    func service(_ service: ReplacePhotoStoreService, error: Error)
}

class ReplacePhotoStoreService: NSObject {
    
    var isVerifyPathAvailable = true
    weak var delegate: ReplacePhotoStoreServiceDelegate?
    
    private lazy var currentSelectedURL : [ReplacePhotoPathTypeIdentifier : URL] = {
        var urlDict = [ReplacePhotoPathTypeIdentifier : URL]()
        for (key, value) in self.historySelectedURL {
            urlDict[key] = value.first
        }
        return urlDict
    }()
    private lazy var historySelectedURL: [ReplacePhotoPathTypeIdentifier : [URL]] = {
        var historyURLs = [ReplacePhotoPathTypeIdentifier : [URL]]()
        do {
            historyURLs[.originPath] = try self.read(identifier: .originPath)
            historyURLs[.toPath] = try self.read(identifier: .toPath)
        }catch {
            self.delegate?.service(self, error: error)
        }
        return historyURLs
    }()
    
    convenience init(delegate: ReplacePhotoStoreServiceDelegate) {
        self.init()
        self.delegate = delegate
    }
    
//    func save(filePath: String, identifier: ReplacePhotoPathTypeIdentifier) -> Bool {
//        let mutableArr = UserDefaults.standard.mutableArrayValue(forKey: identifier.rawValue)
//        mutableArr.add(filePath)
//        UserDefaults.standard.set(mutableArr, forKey: identifier.rawValue)
//        return true
//    }
}

extension ReplacePhotoStoreService {
    
    func set(selectedURL: URL, for key: ReplacePhotoPathTypeIdentifier) {
        currentSelectedURL[key] = selectedURL
        delegate?.service(self, didChange: selectedURL, identifier: key)
    }
    func getSelectedURL(for key: ReplacePhotoPathTypeIdentifier) -> URL? {
        return currentSelectedURL[key]
    }
}

extension ReplacePhotoStoreService {
    
    func save() -> Bool {
        do {
            for (key, value) in currentSelectedURL {
                try save(targetPath: value, identifier: key)
            }
        } catch {
            delegate?.service(self, error: error)
        }
        return true
    }
    
    func read(identifier: ReplacePhotoPathTypeIdentifier) throws -> [URL] {
        let filePath = try bookmarkFolder(identifier: identifier)
        var urlList = [URL]()
        let bookmarkDataList = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        for subpath in bookmarkDataList {
            let data = try Data(contentsOf: subpath)
            var bookmarkDataIsStale = false
            let url = try URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            _ = url.startAccessingSecurityScopedResource()
            urlList.append(url)
        }
        return urlList
    }
    
    // 保存指定 URL 的 bookmarkData
    func save(targetPath: URL, identifier: ReplacePhotoPathTypeIdentifier) throws {
        
        var targetBookmark = try bookmarkFolder(identifier: identifier)
        targetBookmark.appendPathComponent(createBookmarkName())
        let bookMarkData = try targetPath.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: Set<URLResourceKey>([.isDirectoryKey]), relativeTo: nil)
        try bookMarkData.write(to: targetBookmark, options: .atomic)
    }
    
    // 保存的路径
    func bookmarkFolder(identifier: ReplacePhotoPathTypeIdentifier) throws -> URL {
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            throw ReplacePhotoError.isEmpty("沙盒内没有 Library 文件夹")
        }
        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("bookmark")
        url.appendPathExtension(identifier.rawValue)
        if let isDir = url.ml_isDirectory, isDir {
            return url
        }
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }
    
    func createBookmarkName() -> String {
        return String(Date().timeIntervalSince1970) + String(arc4random()) + ".rpd"
    }
}
