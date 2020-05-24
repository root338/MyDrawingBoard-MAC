//
//  ReplacePhotoVC.swift
//  MyDrawingBoard
//
//  Created by GML on 2020/5/24.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

enum ReplacePhotoError : Error {
    case cancelSelectFolder
    case folderIsEmpty
}

class ReplacePhotoVC: NSViewController {

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
            case .success(_): break
                
            default: return
            }
        }
    }
    @IBAction func handleFromFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleToFolder(_ sender: Any) {
//        handleSelectedFolder()
    }
    @IBAction func handleToFolderHistory(_ sender: Any) {
        
    }
    @IBAction func handleReplace(_ sender: Any) {
        
    }
    
    func handleSelectedFolder(completion: (Result<URL, ReplacePhotoError>) -> Void) {
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
