//
//  OpenPanelExtension.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

extension NSOpenPanel {
    
    static func selectedFolder(sheetWindow: NSWindow? = nil, completion: (Bool, URL?) -> Void) -> NSOpenPanel {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        if sheetWindow == nil {
            panel.begin {
                (result) in
                completion( result == .OK, panel.url)
                return
            }
        }else {
            panel.beginSheet(sheetWindow!) {
                (result) in
                completion( result == .OK, panel.url)
                return
            }
        }
        return panel
    }
    
    
}

