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
    /// 仅代表执行完成
    func replaceDidFinish(service: ReplacePhotoService)
}

extension ReplacePhotoService {
    convenience init(delegate: ReplacePhotoServiceDelegate) {
        self.init()
        self.delegate = delegate
    }
}

class ReplacePhotoService: NSObject {
    private(set) var originFolder: URL?
    private(set) var replaceFolder: URL?
    private(set) var types : [String] = ["png", "jpeg"]
    weak var delegate : ReplacePhotoServiceDelegate?
    
    private(set) lazy var log = FileReplaceLogSet()
    
    func run() {
        
        DispatchQueue.global().async {
            do {
                self.log.clear()
                let items = try self.handleSelectedFile()
                self.replace(originItems: items.originFileItems, replaceItems: items.toFileItems)
            } catch let e as ReplacePhotoError {
                self.delegate?.service(self, error: e)
            } catch {
                assert(false, error.localizedDescription)
            }
            self.delegate?.replaceDidFinish(service: self)
        }
    }
    
    func set(originPath: URL?, toPath: URL?) {
        self.originFolder = originPath
        self.replaceFolder = toPath
    }
}

private extension ReplacePhotoService {
    // 处理选择选中的文件
    func handleSelectedFile() throws -> (originFileItems: [PhotoFileItem], toFileItems: [PhotoFileItem]) {
        
        guard let originFolder = self.originFolder, !originFolder.path.isEmpty else {
            throw ReplacePhotoError.isEmpty("来源文件路径不能为空")
        }
        guard let replaceFolder = self.replaceFolder, !replaceFolder.path.isEmpty else {
            throw ReplacePhotoError.isEmpty("目标文件路径不能为空")
        }
        if originFolder == replaceFolder {
            throw ReplacePhotoError.unavailable("源文件路径和目标文件路径不能相同")
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
                    try fileM.removeItem(at: originItem.filePath)
                    _ = try fileM.copyItem(at: newItem.filePath, to: originItem.filePath)
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
    func analysisPhoto(path: URL, isRecursive: Bool = true) -> [PhotoFileItem]? {
        var fileItems = [PhotoFileItem]()
        
        FileManager.default.enumerator(at: path, handle: {
            guard let isDir = try? $1().isDirectory else {
                assert(false, "目录不会为空的，请处理...")
                return .none
            }
            if !isDir, let fileItem = handle(filePath: $0) {
                fileItems.append(fileItem)
            }
            return .none
        })
        return fileItems.count > 0 ? fileItems : nil
    }
    /// 创建图片对象
    func handle(filePath: URL) -> PhotoFileItem? {
        let pathExtension = filePath.pathExtension
        guard types.contains(pathExtension) else {
            return nil
        }
        guard let imagePixelSize = NSImage(byReferencing: filePath).imagePixelSize else {
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
