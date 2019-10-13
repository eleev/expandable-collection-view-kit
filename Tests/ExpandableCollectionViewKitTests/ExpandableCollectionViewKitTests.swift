//
//  ExpandableCollectionViewKitTests.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 13.10.2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest
@testable import ExpandableCollectionViewKit

final class ExpandableCollectionViewKitTests: XCTestCase {
    func testItem() {
        let item = ExpandableItem(title: "Item")
        XCTAssertEqual(item.title, "Item")
        XCTAssertEqual(item.indentLevel, 0)
        XCTAssertEqual(item.parent, nil)
    }

    func testParentedItem() {
        let folder = Folder(title: "Parent Folder") {
            ExpandableItem(title: "Item")
        }
        
        XCTAssertEqual(folder.title, "Parent Folder")
        XCTAssertEqual(folder.indentLevel, 0)
        XCTAssertEqual(folder.parent, nil)
        XCTAssertEqual(folder.subitems.count, 1)
    }
    
    static var allTests = [
        ("testItem", testItem),
        ("testParentedItem", testParentedItem)
    ]
}
