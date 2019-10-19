//
//  AnimationFactory.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 12.10.2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

public enum AnimationFactory {

    // MARK: - Configuration Utility Enums
    
    public enum VDirection {
        case up
        case down
    }
    
    // MARK: - Public Animations
    
    public static func verticalUnfold(duration: TimeInterval, delayFactor: Double = 0, direction: VDirection = .up) -> ExpandableItem.Animation {
        return { cell, indexPath, collectionView, completion in
            
            cell.layer.zPosition = CGFloat(UInt8.max - UInt8(indexPath.row))
            
            var height = cell.bounds.height
            var ydirection = CGFloat.pi / 1.5
            
            if direction == .up {
                height = -height
                ydirection = -ydirection
            }
            
            let identity = CATransform3DIdentity
            let rotation = CATransform3DRotate(identity, ydirection, 1, 0, 0)
            let translation = CATransform3DTranslate(identity, 0, height, 0)
            var transform = CATransform3DConcat(rotation, translation)
            transform.m34 = 1.0 / -200
            
            cell.transform3D = transform
            
            UIView.animate(
            withDuration: duration,
            delay: delayFactor * Double(indexPath.row),
            animations: {
                cell.transform3D = CATransform3DIdentity
            }, completion: completion)
        }
    }
    
    public static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
        return { cell, indexPath, _, _ in
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
    
    public static func revealBehindEachOther(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
        return { cell, indexPath, viewController, _ in
            cell.layer.zPosition = CGFloat(UInt8.max - UInt8(indexPath.row))
            cell.transform = CGAffineTransform(translationX: 0, y: -(cell.bounds.height / 1.5))
            cell.alpha = 0.0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.2,
                options: [.curveEaseOut],
                animations: {
                    cell.alpha = 1.0
                    cell.transform = .identity
            })
        }
    }
    
    public static func moveDownWithBounce(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
        return { cell, indexPath, _, _ in
            cell.layer.zPosition = CGFloat(UInt8.max - UInt8(indexPath.row))
            cell.transform = CGAffineTransform(translationX: 0, y: -(cell.bounds.height / 1.5))
            cell.alpha = 0.0

            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.2,
                options: [.curveEaseIn],
                animations: {
                    cell.alpha = 1.0
                    cell.transform = .identity
            })
        }
    }
    
    public static func moveDown(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
        return { cell, indexPath, _, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: -(cell.bounds.height / 1.5))

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    // MARK: - Experimental animations
    
    static func verticalFold(duration: TimeInterval, delayFactor: Double = 0, direction: VDirection) -> ExpandableItem.Animation {
           return { cell, indexPath, collectionView, completion in
               cell.layer.zPosition = CGFloat(indexPath.row)

               cell.transform3D = CATransform3DIdentity
               var height = cell.bounds.height
               var ydirection = CGFloat.pi / 2
               
               if direction == .up {
                   height = -height
                   ydirection = -ydirection
               }
               
               UIView.animate(
                   withDuration: duration,
                   delay: delayFactor * Double(indexPath.row),
                   animations: {
                       let identity = CATransform3DIdentity
                       
                       let rotation = CATransform3DRotate(identity, ydirection, 1, 0, 0)
                       let translation = CATransform3DTranslate(identity, 0, height, 0)
                       var transform = CATransform3DConcat(rotation, translation)
                       transform.m34 = 1.0 / -200
                       
                       cell.transform3D = transform
               }, completion: completion)
           }
       }
    
    static func slideIn(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
        return { cell, indexPath, collectionView, _ in
            cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func slideOut(duration: TimeInterval, delayFactor: Double = 0) -> ExpandableItem.Animation {
           return { cell, indexPath, collectionView, _ in
               UIView.animate(
                   withDuration: duration,
                   delay: delayFactor * Double(indexPath.row),
                   options: [.curveEaseInOut],
                   animations: {
                    cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
               })
           }
       }
}

extension UICollectionView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleItems.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
