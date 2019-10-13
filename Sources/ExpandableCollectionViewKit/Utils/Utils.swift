//
//  Utils.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation
import struct CoreGraphics.CGFloat

enum Section {
    case main
}

enum UnwrappingError: Error {
    case missingValue
}

extension Optional {
    func tryUnwrap(_ closure: (Wrapped) -> Void) throws {
        switch self {
        case .some(let wrapped):
            closure(wrapped)
        default:
            throw UnwrappingError.missingValue
        }
    }
}

extension NSKeyValueObservation {
    func store(in bag: inout Set<NSKeyValueObservation>) {
        bag.insert(self)
    }
}

extension Int {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
}
