//
//  XCTestManifests.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 13.10.2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ExpandableCollectionViewKitTests.allTests),
    ]
}
#endif
