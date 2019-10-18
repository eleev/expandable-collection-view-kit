//
//  Item.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation
import class UIKit.UIViewController
import class UIKit.UIColor

final public class Item: ExpandableItem {
    
    // MARK: - Typealiases
    
    public typealias Action = (_ indexPath: IndexPath, _ title: String) -> Void
    
    // MARK: - Properties
    
    public private(set) var viewControllerType: UIViewController.Type?
    public private(set) var configuration: ((UIViewController) -> Void)?
    
    public private(set) var action: Action?
    
    private let defaultImageName = "circle.fill"
    private let defaultTintColor = UIColor.systemTeal
    
    // MARK: - Initialisers
    
    public init(title: String,
                action: @escaping Action) {
        super.init(title: title)
        
        self.action = action
        
        tintColor = defaultTintColor
        imageName = defaultImageName
    }
    
    public init(title: String,
                action: Action? = nil,
                viewControllerType: UIViewController.Type? = nil,
                configuration: ((UIViewController) -> Void)? = nil) {
        super.init(title: title)
        
        tintColor = defaultTintColor
        imageName = defaultImageName
        
        self.viewControllerType = viewControllerType
        self.configuration = configuration
    }
    
    // MARK: - Methods
    
    @discardableResult
    public func setViewControllerType(_ viewControllerType: UIViewController.Type, configuration: ((UIViewController) -> Void)? = nil) -> Self {
        self.viewControllerType = viewControllerType
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    public func setAction(_ action: @escaping Action) -> Self {
        self.action = action
        return self
    }
}
