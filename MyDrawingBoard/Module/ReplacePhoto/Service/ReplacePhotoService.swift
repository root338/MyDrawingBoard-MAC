//
//  ReplacePhotoService.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/5/25.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

protocol ReplacePhotoServiceDelegate : NSObjectProtocol {
    func service(_ service: ReplacePhotoService, error: Error)
    func service(_ service: ReplacePhotoService, willReplace item: PhotoFileItem, toItem: PhotoFileItem) -> Bool
    func service(_ service: ReplacePhotoService, didReplace item: PhotoFileItem, toItem: PhotoFileItem)
    func replaceDidFinish(service: ReplacePhotoService)
}

extension ReplacePhotoService {
    convenience init(delegate: ReplacePhotoServiceDelegate) {
        self.init()
        self.delegate = delegate
    }
}

class ReplacePhotoService: NSObject {
    private(set) var originFolder: String?
    private(set) var replaceFolder: String?
    private(set) var types : [String] = ["png", "jpeg"]
    weak var delegate : ReplacePhotoServiceDelegate?
    
    private(set) lazy var log = FileReplaceLogSet()
    
    func run() {
        
        do {
            let items = try handleSelectedFile()
            replace(originItems: items.originFileItems, replaceItems: items.toFileItems)
        } catch let e as ReplacePhotoError {
            delegate?.service(self, error: e)
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    func set(originPath: String, toPath: String) {
        self.originFolder = originPath
        self.replaceFolder = toPath
    }
}

private extension ReplacePhotoService {
    // 处理选择选中的文件
    func handleSelectedFile() throws -> (originFileItems: [PhotoFileItem], toFileItems: [PhotoFileItem]) {
        guard let originFolder = self.originFolder, !originFolder.isEmpty else {
            throw ReplacePhotoError.isEmpty("来源文件路径不能为空")
        }
        guard let replaceFolder = self.replaceFolder, !replaceFolder.isEmpty else {
            throw ReplacePhotoError.isEmpty("目标文件路径不能为空")
        }
        guard let originFileItems = analysisPhoto(path: originFolder) else {
            throw ReplacePhotoError.isEmpty("来源文件对应没有内容")
        }
        guard let replaceFileItems = analysisPhoto(path: replaceFolder) else {
            throw ReplacePhotoError.isEmpty("目标文件对应没有内容")
        }
        return (originFileItems, replaceFileItems)
    }
    // 替换
    func replace(originItems: [PhotoFileItem], replaceItems: [PhotoFileItem]) {
        let fileM = FileManager.default
        
        for originItem in originItems {
            var isReplace : Bool? = nil
            for newItem in replaceItems {
                guard originItem.pixelSize.equalTo(newItem.pixelSize), originItem.format == newItem.format else {
                    continue
                }
                guard delegate?.service(self, willReplace: originItem, toItem: newItem) ?? true else {
                    continue
                }
                do {
                    try fileM.removeItem(atPath: originItem.filePath)
                    try fileM.copyItem(atPath: newItem.filePath, toPath: originItem.filePath)
                    _ = log.add(log: FileReplaceResult(originItem: originItem, newItem: newItem, error: nil))
                    delegate?.service(self, didReplace: originItem, toItem: newItem)
                    isReplace = true
                } catch {
                    let result = log.add(log: FileReplaceResult(originItem: originItem, newItem: newItem, error: error))
                    delegate?.service(self, error: ReplacePhotoError.operateFailure(item: result))
                    isReplace = false
                }
                break
            }
            if isReplace == nil {
                let result = log.add(log: FileReplaceResult(originItem: originItem, newItem: nil, error: ReplacePhotoError.notFind))
                delegate?.service(self, error: ReplacePhotoError.operateFailure(item: result))
            }
        }
    }
    
    /// 分析路径中图片
    func analysisPhoto(path: String, isRecursive: Bool = false) -> [PhotoFileItem]? {
        var fileItems = [PhotoFileItem]()
        FileManager.default.enumerator(at: path, deepRecursion: isRecursive) { (filePath, isDir) -> FileManager.EnumeratorOperate in
            if !isDir, let fileItem = handle(filePath: filePath) {
                fileItems.append(fileItem)
            }
            return .none
        }
        return fileItems.count > 0 ? fileItems : nil
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

extension ReplacePhotoServiceDelegate {
    func service(_ service: ReplacePhotoService, willReplace item: PhotoFileItem, toItem: PhotoFileItem) -> Bool {
        return true
    }
    func replaceDidFinish(service: ReplacePhotoService) {}
    func service(_ service: ReplacePhotoService, didReplace item: PhotoFileItem, toItem: PhotoFileItem) {}
}
