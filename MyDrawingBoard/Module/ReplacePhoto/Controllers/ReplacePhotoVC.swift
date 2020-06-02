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
    
    private lazy var service = ReplacePhotoService(delegate: self)
    private lazy var textBuilder = GMLRichTextBuilder()
    private lazy var attributesBuilder = GMLAttributesBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "替换图片"
        
        textBuilder.defaultAttributes = attributesBuilder.font(GMLFont.systemFont(ofSize: 11)).popLast()
    }
    
    @IBAction func handlePOP(_ sender: Any) {
        guard let presentingVC = self.presentingViewController else { return }
        presentingVC.dismiss(self)
    }
    @IBAction func handleOriginFolder(_ sender: Any) {
        handleSelectedFolder { (result) in
            switch result {
            case .success(let fileURL):
                originFolderLabel?.stringValue = fileURL.path
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
                replaceFolderLabel?.stringValue = fileURL.path
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
    
    func handleSelectedFolder(completion: (SelectedFileURLResult) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        guard panel.runModal() == .OK else {
            completion(Result.failure(ReplacePhotoError.cancelSelectFolder))
            return
        }
        guard let selectedURL = panel.url else {
            completion(Result.failure(ReplacePhotoError.isEmpty("选择的路径为空")))
            return
        }
        completion(Result.success(selectedURL))
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
        logTextView.textStorage?.append(att!)
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
