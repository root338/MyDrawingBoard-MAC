//
//  AssetsVC.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

class AssetsVC: NSViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func handleAdd(_ sender: Any) {
         NSOpenPanel()
    }
}

extension AssetsVC: NSOutlineViewDataSource, NSOutlineViewDelegate {
    //MARK:- NSOutlineViewDataSource
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 1
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return "111111"
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return "1111111"
    }
    
    //MARK:- NSOutlineViewDelegate
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if tableColumn == nil { return nil }
        
        guard let cell = outlineView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = item as! String
        return cell
    }
}
