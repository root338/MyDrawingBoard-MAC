//
//  MyMainPanel.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/5/22.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

class MyMainPanel: NSViewController {
    
    @IBOutlet weak var listView: NSTableView!
    
    lazy var tools : [ToolsItem] = [
        ToolsItem(name: "替换图标", functionalDescription: "替换文件夹中同像素的图片", targetClass: ReplacePhotoVC.self),
        ToolsItem(name: "Assets 管理", functionalDescription: "基本项目 Assets 的管理，现在图片太多，简化命名时的复制粘贴", targetClass: AssetsVC.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension MyMainPanel : NSTableViewDataSource, NSTableViewDelegate {
    //MARK:- NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tools.count
    }
    
    //MARK:- NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard tableColumn != nil || tools.count <= row else { return nil }
        let item = tools[row]
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: tableView.delegate) as? MainToolCell else {
            return nil
        }
        cell.textField?.stringValue = item.name
        cell.subtitleLabel.stringValue = item.functionalDescription
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = listView.selectedRow;
        if selectedRow < 0 { return }
        let item = tools[selectedRow]
        listView.deselectRow(selectedRow)
        let targetVC = item.targetClass.init()
        self.presentAsModalWindow(targetVC)
    }
}
