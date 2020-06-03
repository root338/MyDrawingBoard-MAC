//
//  AssetsDataService.swift
//  MyDrawingBoard
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 GML. All rights reserved.
//

import Cocoa

protocol AssetsDataServiceDelegate: NSObjectProtocol {
    func service(_ service: AssetsDataService)
}

class AssetsDataService: NSObject {
    
    lazy var assetsPaths = [AssetsPath]()
    
}
