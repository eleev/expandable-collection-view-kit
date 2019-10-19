//
//  ExpandableItem.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

/// Base class for the expandable items. Don't use this class to fill in the expandable table view, since it's not inended to be used in that way.
public class ExpandableItem: Hashable {
    
    // MARK: - Typealiases
    
    /// Animation typealias that specifies the required closure signature for a valid animation for `ExpandableCollectionViewKit` framework.
    /// - Parameter cell: is a `UICollectionViewCell` instance that will be the main subject of animation
    /// - Parameter indexPath: is an `IndexPath` instance
    /// - Parameter collectionView: is the `UICollectionView` instance that represents the current collection view
    /// - Parameter completion: is an optional completion closure that is specified by the following signature: `((Bool) -> Void)?`
    public typealias Animation = (_ cell: UICollectionViewCell, _ indexPath: IndexPath, _ collectionView: UICollectionView, _ completion: ((Bool) -> Void)?) -> Void
    
    // MARK: - Properties
    
    public weak var parent: ExpandableItem? = nil
    public var title: String
    public var indentLevel: Int
    
    public var imageName: String? = nil
    public var tintColor: UIColor = .systemGray

    // MARK: - Private propeties
    
    private let identifier = UUID()

    // MARK: - Initializers
    
    public init(title: String) {
        self.title = title
        indentLevel = 0
    }
    
    public init(title: String,
                parent: ExpandableItem) {
        self.title = title
        self.parent = parent
        indentLevel = 0
    }
    
    public init(title: String,
                parent: ExpandableItem,
                indentLevel: Int) {
        self.title = title
        self.parent = parent
        self.indentLevel = indentLevel
    }
    
    // MARK: - Hashables
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: ExpandableItem, rhs: ExpandableItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension ExpandableItem {
    @discardableResult
    func setIndentLevel(_ indentLevel: Int) -> Self {
        self.indentLevel = indentLevel
        return self
    }
    
    @discardableResult
    func setParent(_ parent: ExpandableItem) -> Self {
        self.parent = parent
        return self
    }
}

extension ExpandableItem {
    func incrementIndentLevel(for items: ExpandableItem...) {
        items.forEach { item in
            item.setParent(self)
        }
    }

    func incrementIndentLevel(for items: [ExpandableItem]) {
        items.forEach { item in
            item.setParent(self)
        }
    }

    func incrementIndentLevel(for wrapper: ExpandableItems) {
        wrapper.items.forEach { item in
            item.setParent(self)
        }
    }
}

// MARK: - Modifiers Externsion
public extension ExpandableItem {

    @objc
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    @objc
    @discardableResult
    func setImage(systemName imageName: String) -> Self {
        self.imageName = imageName
        return self
    }
    
    @objc
    @discardableResult
    func setTintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }
}
