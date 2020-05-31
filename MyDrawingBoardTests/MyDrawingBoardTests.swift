//
//  MyDrawingBoardTests.swift
//  MyDrawingBoardTests
//
//  Created by apple on 2020/5/22.
//  Copyright © 2020 GML. All rights reserved.
//

import XCTest
@testable import MyDrawingBoard

class MyDrawingBoardTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func testBuilderAttributes() throws {
        let builder = GMLAttributesBuilder()
        let font = NSFont.systemFont(ofSize: 12)
        
        _ = builder.push().font(font)
            .backgroundColor(NSColor.black)
        
        print(builder.pop()!)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
