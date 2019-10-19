//
//  Animator.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 07/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

final class Animator {
    
    // MARK: - Properties
    
    private var hasAnimatedAllCells = false
    private let animation: ExpandableItem.Animation

    // MARK: - Initializers
    
    init(animation: @escaping ExpandableItem.Animation) {
        self.animation = animation
    }

    // MARK: - Methods
    
    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView, completion: ((Bool) -> Void)? = nil) {
        guard !hasAnimatedAllCells else { return }
        animation(cell, indexPath, collectionView, completion)
        hasAnimatedAllCells = collectionView.isLastVisibleCell(at: indexPath)
    }
}
