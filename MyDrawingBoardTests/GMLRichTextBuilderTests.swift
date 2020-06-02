//
//  GMLRichTextBuilderTests.swift
//  MyDrawingBoardTests
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 GML. All rights reserved.
//

import XCTest
@testable import MyDrawingBoard

class GMLRichTextBuilderTests: XCTestCase {
    
    func testGetAttributes() throws {
        
        let textBuilder = GMLRichTextBuilder()
        _ = textBuilder.push("")
        var attributes = NSMutableAttributedString()
        print(textBuilder.lastAttributes())
        attributes = textBuilder.append("A", attributes: [
            .font : NSFont.systemFont(ofSize: 9),
            .foregroundColor : NSColor.blue
        ])
        .append("B", attributes: [
            .font : NSFont.systemFont(ofSize: 10),
            .foregroundColor : NSColor.black
        ])
        .append("C", attributes: [
            .font : NSFont.systemFont(ofSize: 11),
            .foregroundColor : NSColor.red
        ])
        .last!
        print(textBuilder.lastAttributes())
    }
}
