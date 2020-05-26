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

    @IBOutlet weak var fromFolderLabel: SelectedFolderLabel!
    @IBOutlet weak var toFolderLabel: SelectedFolderLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "替换图片"
    }
    
    @IBAction func handlePOP(_ sender: Any) {
        guard let presentingVC = self.presentingViewController else { return }
        presentingVC.dismiss(self)
    }
    @IBAction func handleFromFolder(_ sender: Any) {
        handleSelectedFolder { (result) in
            switch result {
            case .success(let fileURL):
                fromFolderLabel?.stringValue = fileURL.absoluteString
            default: return
            }
        }
    }
    @IBAction func handleFromFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleToFolder(_ sender: Any) {
        handleSelectedFolder { (result) in
            switch result {
            case .success(let fileURL):
                toFolderLabel?.stringValue = fileURL.absoluteString
            default: return
            }
        }
    }
    @IBAction func handleToFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleReplace(_ sender: Any) {
        
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
            completion(Result.failure(ReplacePhotoError.folderIsEmpty))
            return
        }
        completion(Result.success(selectedURL))
    }
}
