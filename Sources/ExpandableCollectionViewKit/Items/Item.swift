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
    
    // MARK: - Properties
    
    public private(set) var viewControllerType: UIViewController.Type?
    public private(set) var configuration: ((UIViewController) -> Void)?
    
    private let defaultImageName = "circle.fill"
    private let defaultTintColor = UIColor.systemTeal
    
    // MARK: - Initialisers
    
    public init(title: String,
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
}
