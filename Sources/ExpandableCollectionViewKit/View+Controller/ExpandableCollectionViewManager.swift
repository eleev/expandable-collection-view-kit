//
//  ExpandableCollectionViewManager.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import Combine

final public class ExpandableCollectionViewManager: NSObject {
    
    // MARK: - Enum types
    
    public enum UnfoldAnimationType {
        case simple
        /// Custom animation that can be constructed manually of by using the `AnimationFactory` type
        case custom(Animation)
    }
    
    // MARK: - Properties
    
    private var diselectedIndexPath: IndexPath?
    
    // MARK: - Private properties
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, ExpandableItem>! = nil
    private lazy var collectionView: UICollectionView! = nil
    private let parentViewController: UIViewController
    
    private lazy var menuItems: [ExpandableItem] = []
    private lazy var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public properties
    
    public var itemHeightDimension: NSCollectionLayoutDimension = .absolute(44) {
        didSet {
            let layout = generateLayout()
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    public var sectionContentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
    public var onCellTapHandler: ((UIViewController) -> Void)? = nil
    
    public var unfoldAnimation: UnfoldAnimationType = .simple
    
    // MARK: - Initializers
    
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()

        configure()
    }
    
    public init(parentViewController: UIViewController,
                @ExpandableItemBuilder builder: () -> ExpandableItems) {
        self.parentViewController = parentViewController
        super.init()

        appendItems(builder: builder)
        configure()
    }
      
    public init(parentViewController: UIViewController,
                @ExpandableItemBuilder builder: () -> ExpandableItem) {
        self.parentViewController = parentViewController
        super.init()
        
        let items = ExpandableItems(items:  [builder()])
        appendItems(builder: { items } )
        configure()
    }
    
    // MARK: - Private setup
    
    private func configure() {
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Methods
    
    public func appendItems(@ExpandableItemBuilder builder: () -> ExpandableItems) {
        menuItems += builder().items

        // No need to store the publisher since it's a one time future + sink chain
        let _ = Future<Void, Never>() { promise in
            // Recursively traverse all the data source hierarchy and calculate the indent level for each subtree, which will make all the elements to have the corresponding leading anchor paddings
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.menuItems.forEach { (zeroLevelItems) in
                    zeroLevelItems.setIndentLevel(-1)
                    incrementIndentLevel(for: zeroLevelItems)
                }

                func incrementIndentLevel(for item: ExpandableItem) {
                    item.setIndentLevel((item.parent?.indentLevel ?? -1) + 1)

                    guard let folder = item as? Folder else { return }
                    folder.subitems.forEach { item in
                        incrementIndentLevel(for: item)
                    }
                }
                promise(.success(Void()))
            }
        }
        .subscribe(on: RunLoop.main)
        .sink { [weak self] in
            self?.updateDataSource()
        }
    }
}

private extension ExpandableCollectionViewManager {
    
    func updateDataSource(animatingDifferences isAnimated: Bool = true, completion: @escaping () -> Void = { }) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            let snapshot = self.snapshotForCurrentState()
            self.dataSource.apply(snapshot, animatingDifferences: isAnimated, completion: completion)
        }
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: parentViewController.view.bounds, collectionViewLayout: generateLayout())
        parentViewController.view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ExpandableItemCell.self, forCellWithReuseIdentifier: ExpandableItemCell.reuseIdentifier)
        self.collectionView = collectionView
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource
            <Section, ExpandableItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, menuItem: ExpandableItem) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ExpandableItemCell.reuseIdentifier,
                    for: indexPath) as? ExpandableItemCell else { fatalError("Could not create new cell") }
                
                cell.configureTypeImageView()
                cell.configureChevronImageView()
                
                cell.label.text = menuItem.title
                cell.indentLevel = menuItem.indentLevel
                cell.itemTintColor = menuItem.tintColor
                
                switch menuItem {
                case let folder as Folder:
                    cell.subitems = folder.subitems.count
                    cell.isGroup = folder.isGroup
                    cell.isExpanded = folder.isExpanded
                    cell.isChevronVisible = folder.isChevronVisible
                    cell.shouldDisplayItemsCount = folder.isItemsCountVisible
                    
                    try? folder.imageName.tryUnwrap { cell.itemImageName = $0 }
                case menuItem as Item:
                    try? menuItem.imageName.tryUnwrap { cell.itemImageName = $0 }
                    
                    cell.subitemsLabel.text = nil
                    cell.isGroup = false
                default: ()
                }
              
                if case .custom(let animation) = self.unfoldAnimation {
                    self.animateUnfoldIfNeeded(cell: cell, for: indexPath, with: animation)
                }
                
                return cell
        }
        
        // Load the initial data
        updateDataSource(animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionContentInsets
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, ExpandableItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ExpandableItem>()
        snapshot.appendSections([Section.main])
        func addItems(_ menuItem: ExpandableItem) {
            snapshot.appendItems([menuItem])
            
            guard let folder = menuItem as? Folder, folder.isExpanded else { return }
            folder.subitems.forEach { addItems($0) }
        }
        menuItems.forEach { addItems($0) }
        return snapshot
    }
}

extension ExpandableCollectionViewManager {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        diselectedIndexPath = nil
    }
}
 
extension ExpandableCollectionViewManager: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let folder = menuItem as? Folder {
            folder.action?(indexPath, folder.title, !folder.isExpanded)
            
            if folder.isGroup {
                folder.isExpanded.toggle()
                
                diselectedIndexPath = folder.isExpanded ? indexPath : nil
                
                if let cell = collectionView.cellForItem(at: indexPath) as? ExpandableItemCell {
                    cell.isExpanded = folder.isExpanded
                    
                    updateDataSource()
                }
            }
        } else if let item = menuItem as? Item {
            item.action?(indexPath, item.title)
            
            if let viewControllerType = item.viewControllerType,
                let onCellTapHandler = self.onCellTapHandler {
                // Instantiate and apply optional configuration closure to the destination view controller
                let destinationViewController = viewControllerType.init()
                item.configuration?(destinationViewController)
                
                onCellTapHandler(destinationViewController)
            }
        }
    }
}

private extension ExpandableCollectionViewManager {
    func animateUnfoldIfNeeded(cell: UICollectionViewCell, for indexPath: IndexPath, with animation: @escaping Animation) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard
                let diselectedIndexPath = self.diselectedIndexPath,
                let _ = self.dataSource.itemIdentifier(for: diselectedIndexPath) as? Folder
                else { return }
            
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: self.collectionView)
        }
    }
}
