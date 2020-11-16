//
//  ReplaceService.swift
//  ReplacePhoneTools
//
//  Created by apple on 2020/9/21.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation

class ReplaceService: NSObject {
    let info: ReplaceInfo
    lazy var service: ReplacePhotoService = {
        let service = ReplacePhotoService(delegate: self)
        service.originFolderIsDepth = self.info.urlIsDepth
        service.replaceFolderIsDepth = self.info.replaceURLIsDepth
        return service
    }()
    
    lazy var waitSemaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    init(info: ReplaceInfo) {
        self.info = info
    }
    
    func runReplace() throws -> (code: Int, msg: String?) {
        service.set(originPath: info.url, toPath: info.replaceURL)
        service.run()
        waitSemaphore.wait()
        return (service.log.totalCount <= 0 ? -1 : service.log.errorCount, resultAnalysis())
    }
}

extension ReplaceService : ReplacePhotoServiceDelegate {
    func service(_ service: ReplacePhotoService, error: Error) {
        print(analysisError(error))
    }
    func replaceDidFinish(service: ReplacePhotoService) {
        waitSemaphore.signal()
    }
    
    private func analysisError(_ error: Error) -> String {
        
        if let e = error as? ReplacePhotoError {
            switch e {
            case .cancelSelectFolder:
                return "没有选择文件路径"
            case .isEmpty(let msg):
                return msg
            case .unavailable(let msg):
                return msg
            case .notFind:
                return "没有找到"
            case .operateFailure(let item):
                var msg = item.originItem.filePath.path
                if item.newItem != nil {
                    msg.append("  >>> " + item.newItem!.filePath.path)
                }
                if item.error != nil {
                    msg.append(analysisError(item.error!))
                }else {
                    msg.append(" 替换失败，错误未知！！")
                }
                return msg
            }
        }else {
            return "  错误: " + error.localizedDescription
        }
    }
    
    private func resultAnalysis() -> String? {
        let log = service.log
        let totalCount = log.totalCount
        let errorCount = log.errorCount
        if totalCount > 0 && errorCount == 0 {
            return nil
        }
        if totalCount == 0 {
            return "目录不存在图片资源 (errCode -1)"
        }
        if totalCount > 0 && totalCount == errorCount {
            return "所需要替换的资源全部没有找到(errCode all)"
        }
        if totalCount > 0 && errorCount > 0 {
            return "总共\(totalCount)个图片，替换失败\(errorCount)个 (errCode \(errorCount)"
        }
        return nil
    }
}

