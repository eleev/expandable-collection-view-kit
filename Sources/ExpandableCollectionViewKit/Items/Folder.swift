//
//  Folder.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation
import class UIKit.UIColor

final public class Folder: ExpandableItem {
    
    // MARK: - Typealiases

    public typealias Action = (_ indexPath: IndexPath, _ title: String, _ isExpanded: Bool) -> Void

    // MARK: - Properties
    
    public private(set) var subitems: [ExpandableItem] = []
        
    public private(set) var isItemsCountVisible: Bool = false
    public var isChevronVisible: Bool = true
    public var isExpanded: Bool = false
    
    public var chevronAnimationDuration: TimeInterval = 0.3
    
    public var isGroup: Bool {
        return subitems.count > 0
    }

    public private(set) var action: Action?
    
    private let defaultImageName = "rectangle.stack.fill"
    private let defaultTintColor = UIColor.systemGray2
    
    // MARK: - Initializers
    
    public init(title: String,
                isExpanded: Bool = false,
                isItemsCountVisible: Bool = false,
                action: Action? = nil) {
        super.init(title: title)
        self.isExpanded = isExpanded
        self.isItemsCountVisible = isItemsCountVisible
        self.action = action
        
        configureDefaults()
    }
    
    public init(title: String,
                isExpanded: Bool = false,
                isItemsCountVisible: Bool = false,
                action: Action? = nil,
                @ExpandableItemBuilder subitems: () -> ExpandableItems) {
        super.init(title: title)
        self.isExpanded = isExpanded
        self.isItemsCountVisible = isItemsCountVisible
        self.action = action
        
        configureDefaults()
        
        let subitems = subitems().items
        incrementIndentLevel(for: subitems)
        self.subitems = subitems
    }
    
    public init(title: String,
                isExpanded: Bool = false,
                isItemsCountVisible: Bool = false,
                action: Action? = nil,
                @ExpandableItemBuilder subitems: () -> ExpandableItem) {
        super.init(title: title)
        self.isExpanded = isExpanded
        self.isItemsCountVisible = isItemsCountVisible
        self.action = action
        
        configureDefaults()
        
        let subitems = [subitems()]
        incrementIndentLevel(for: subitems)
        self.subitems = subitems
    }
  
    // MARK: - Methods
    
    @discardableResult
    func remove(at index: Int) -> Self {
        subitems.remove(at: index)
        return self
    }
    
    @discardableResult
    public func isExpanded(_ isExpanded: Bool) -> Self {
        self.isExpanded = isExpanded
        return self
    }

    @discardableResult
    public func isItemsCountVisible(_ isItemsCountVisible: Bool) -> Self {
        self.isItemsCountVisible = isItemsCountVisible
        return self
    }
  
    @discardableResult
    public func addItem(@ExpandableItemBuilder build: () -> ExpandableItems) -> Self {
        let items = build().items
        incrementIndentLevel(for: items)
        subitems += items
        return self
    }
    
    @discardableResult
    public func isChevronVisible(_ isChevronVisible: Bool) -> Self {
        self.isChevronVisible = isChevronVisible
        return self
    }
    
    @discardableResult
    public func setChevronAnimationDuration(_ chevronAnimationDuration: TimeInterval) -> Self {
        self.chevronAnimationDuration = chevronAnimationDuration
        return self
    }
    
    @discardableResult
    public func setAction(_ action: @escaping Action) -> Self {
        self.action = action
        return self
    }
}

private extension Folder {
    func configureDefaults() {
        imageName = defaultImageName
        tintColor = defaultTintColor
    }
}
