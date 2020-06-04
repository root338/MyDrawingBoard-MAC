//
//  ReplacePhotoVC.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/5/24.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

typealias SelectedFileURLResult = Result<URL, ReplacePhotoError>

class ReplacePhotoVC: NSViewController {

    @IBOutlet weak var originFolderLabel: SelectedFolderLabel!
    @IBOutlet weak var replaceFolderLabel: SelectedFolderLabel!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet weak var logScrollView: NSScrollView!
    
    @IBOutlet weak var logClipView: NSClipView!
    private lazy var service = ReplacePhotoService(delegate: self)
    private lazy var textBuilder = GMLRichTextBuilder()
    private lazy var attributesBuilder = GMLAttributesBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textBuilder.defaultAttributes = attributesBuilder.font(ofSize: 11).popLast()
    }
    
    @IBAction func handleOriginFolder(_ sender: Any) {
        handleSelectedFolder { (result) in
            switch result {
            case .success(let fileURL):
                self.originFolderLabel?.stringValue = fileURL.path
            default: return
            }
        }
    }
    @IBAction func handleFromFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleReplaceFolder(_ sender: Any) {
        handleSelectedFolder { (result) in
            switch result {
            case .success(let fileURL):
                self.replaceFolderLabel?.stringValue = fileURL.path
            default: return
            }
        }
    }
    @IBAction func handleToFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleReplace(_ sender: Any) {
        logTextView.textStorage?.setAttributedString(NSAttributedString())
        service.set(originPath: originFolderLabel.stringValue, toPath: replaceFolderLabel.stringValue)
        service.run()
    }
    
    func handleSelectedFolder(completion: @escaping (SelectedFileURLResult) -> Void) {
        _ = NSOpenPanel.showToCurrentWindow({
            switch $0 {
            case .success(let url):
                completion(Result.success(url))
            case .failure(let err):
                let error : ReplacePhotoError = (err == .cancel) ? .cancelSelectFolder : .isEmpty("选择的路径为空")
                completion(Result.failure(error))
            }
        })
    }
}

extension ReplacePhotoVC: ReplacePhotoServiceDelegate {
    
    func service(_ service: ReplacePhotoService, error: Error) {
        logText(append: textBuilder
            .append(analysisError(error), attributes: errorAttributes())
            .append(.linebreak).popLast())
    }
    
    func service(_ service: ReplacePhotoService, didReplace item: PhotoFileItem, toItem: PhotoFileItem) {
        let text = item.filePath + " 替换成 " + toItem.filePath + " 成功"
        logText(append: textBuilder.append(text, attributes: defaultAttributes()).append(.linebreak).popLast())
    }
    
    func replaceDidFinish(service: ReplacePhotoService) {
        
        let totalCount = service.log.totalCount
        if totalCount == 0 {
            return
        }
        
        var text = "执行完成！！！ 共有 "
        let insertLocation = text.count
        text += " 文件，"
        
        let errorCount = service.log.errorCount
        let isAllSuccess = errorCount == 0
        let isAllError = isAllSuccess ? false : totalCount == errorCount
        let suffixStr = isAllSuccess ? "全部替换成功" : (isAllError ? "全部替换失败" : "\(errorCount) 个文件替换失败")
        logText(append: textBuilder
            .append(text, attributes: defaultAttributes())
            .insert("\(service.log.totalCount)", attributes: errorAttributes(), at: insertLocation)
            .append(suffixStr, attributes: errorAttributes())
            .popLast())
        
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
                var msg = item.originItem.filePath
                if item.newItem != nil {
                    msg.append("  >>> " + item.newItem!.filePath)
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
    
    private func logText(append att: NSAttributedString?) {
        if att == nil {
            return
        }
        DispatchQueue.main.async {
            self.logTextView.textStorage?.append(att!)
            self.logClipView.scroll(to: NSPoint(x: 0, y: self.logScrollView.contentSize.height - self.logScrollView.bounds.height))
        }
    }
    
    private func defaultAttributes() -> GMLAttributesSet {
        let identifier = "defaultAttributes"
        if let attributes = attributesBuilder.attributes(for: identifier) {
            return attributes
        }
        return attributesBuilder.push(identifier: identifier).foregroundColor(GMLColor.black).attributes(for: identifier)!
    }
    
    private func errorAttributes() -> GMLAttributesSet {
        let identifier = "errorAttributes"
        if let att = attributesBuilder.attributes(for: identifier) {
            return att
        }
        return attributesBuilder.push(identifier: identifier).foregroundColor(GMLColor.red).attributes(for: identifier)!
    }
}
