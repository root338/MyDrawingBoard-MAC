//
//  SelectedFolderLabel.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/5/24.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

class SelectedFolderLabel: NSTextField {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let types : [NSPasteboard.PasteboardType] = [
        .string,
        .png,
        .URL,
        .fileURL,
        .fileContents
        ]
        self.registerForDraggedTypes(types)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("")
        return NSDragOperation.copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let items = sender.draggingPasteboard.pasteboardItems else { return false }
        for item in items {
            for type in item.types {
                if let str = item.string(forType: type) {
                    let subpaths = FileManager.default.subpaths(atPath: str)
                    print(subpaths)
                }
                if let data = item.data(forType: type) {
                    print(data)
                }
                if let list = item.propertyList(forType: type) {
                    print(list)
                }
            }
        }
        
        return true
    }
}
