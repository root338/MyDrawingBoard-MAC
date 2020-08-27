//
//  SelectedFolderLabel.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/5/24.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

protocol SelectedFolderLabelDragDelegate : NSObjectProtocol {
    func dragDidChange(label: SelectedFolderLabel)
}

class SelectedFolderLabel: NSTextField {
    weak var dragDelegate : SelectedFolderLabelDragDelegate?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let types : [NSPasteboard.PasteboardType] = [
            .fileURL,
        ]
        self.registerForDraggedTypes(types)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let items = sender.draggingPasteboard.pasteboardItems else { return false }
        for item in items {
            for type in item.types {
                switch type {
                case .fileURL:
                    guard let filePath = item.string(forType: type) else { continue }
                    guard let targetURL = URL(string: filePath) else { continue }
                    guard targetURL.path.ml_isFileDirectory != nil else { continue }
                    self.stringValue = targetURL.path
                    dragDelegate?.dragDidChange(label: self)
                    return true
                default:
                    continue
                }
            }
        }
        return false
    }
}
