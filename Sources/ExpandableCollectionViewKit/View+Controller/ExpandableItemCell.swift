//
//  ExpandableItemCell.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

final class ExpandableItemCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Settings
    
    var chevronAnimationDuration: TimeInterval = 0.3
    
    // MARK: - Properties
    
    let label = UILabel()
    let subitemsLabel = UILabel()
    let containerView = UIView()
    let chevronImageView = UIImageView()
    let typeImage = UIImageView()
    var subitems: Int = 0
    
    var isChevronVisible: Bool = true {
        didSet {
            chevronImageView.isHidden = !isChevronVisible
        }
    }
      
    var shouldDisplayItemsCount: Bool = false {
        didSet {
            onExpansionUpdate()
        }
    }
    
    var itemImageName: String = "" {
        didSet {
            let name = itemImageName
            guard
                name != oldValue,
                let image = UIImage(systemName: name) else { return }
            itemImage = image
            typeImage.image = image
        }
    }

    var itemTintColor: UIColor = .systemTeal {
        didSet {
            updateTypeImageViewTintColor()
        }
    }
    
    private lazy var itemImage = UIImage(systemName: itemImageName)
    
    var indentLevel: Int = 0 {
        didSet {
            indentContraint.constant = CGFloat(imageInset * indentLevel.cgFloat)
        }
    }
    var isExpanded = false {
        didSet {
            configureChevronImageView()
            configureTypeImageView()
            
            if shouldDisplayItemsCount {
                onExpansionUpdate()
            }
        }
    }
    var isGroup = false {
        didSet {
            configureChevronImageView()
            configureTypeImageView()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            configureChevronImageView()
        }
    }
    override var isSelected: Bool {
        didSet {
            configureChevronImageView()
        }
    }
    
    fileprivate var indentContraint: NSLayoutConstraint! = nil
    fileprivate let inset = CGFloat(10)
    fileprivate lazy var imageInset = CGFloat(25)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChevronImageView()
        configureTypeImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell Configuration
extension ExpandableItemCell {
    
    func configure() {
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(chevronImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        containerView.addSubview(label)
        
        subitemsLabel.translatesAutoresizingMaskIntoConstraints = false
        subitemsLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subitemsLabel.textColor = .systemGray2
        subitemsLabel.adjustsFontForContentSizeCategory = true
        subitemsLabel.textAlignment = .right
        containerView.addSubview(subitemsLabel)
        
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(typeImage)
        
        indentContraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset)
        NSLayoutConstraint.activate([
            indentContraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            typeImage.heightAnchor.constraint(equalToConstant: imageInset),
            typeImage.widthAnchor.constraint(equalToConstant: imageInset),
            typeImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: typeImage.trailingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: subitemsLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            subitemsLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: inset),
            subitemsLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -inset),
            subitemsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subitemsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
            chevronImageView.heightAnchor.constraint(equalToConstant: imageInset),
            chevronImageView.widthAnchor.constraint(equalToConstant: imageInset),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
    }
    
    func configureTypeImageView() {
        typeImage.image = itemImage
        typeImage.contentMode = .scaleAspectFit
        
        updateTypeImageViewTintColor()
    }
    
    func updateTypeImageViewTintColor() {
        let highlighted = isHighlighted || isSelected
        typeImage.tintColor = highlighted ? .gray : itemTintColor
    }
    
    func configureChevronImageView() {
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevron = rtl ? "chevron.left" : "chevron.right" // SFSymbols image name id
        let chevronSelected = rtl ? "chevron.left" : "chevron.right" // SFSymbols image name id
        let highlighted = isHighlighted || isSelected
        
        if isGroup {
            let imageName = highlighted ? chevronSelected : chevron
            let image = UIImage(systemName: imageName)
            
            chevronImageView.image = image
            chevronImageView.contentMode = .scaleAspectFit
            
            let rtlMultiplier = rtl ? CGFloat(-1.0) : CGFloat(1.0)
            let rotationTransform = isExpanded ?
                CGAffineTransform(rotationAngle: rtlMultiplier * CGFloat.pi / 2) :
                CGAffineTransform.identity
            
            UIView.animate(withDuration: chevronAnimationDuration) {
                self.chevronImageView.transform = rotationTransform
            }
        } else {
            chevronImageView.image = nil
        }
        
        chevronImageView.tintColor = highlighted ? .gray : .systemGray2
    }
    
    func onExpansionUpdate() {
        if subitems > 0, !isExpanded, shouldDisplayItemsCount {
            UIView.transition(with: subitemsLabel,
                              duration: chevronAnimationDuration,
                              options: .transitionFlipFromTop,
                              animations: { [weak self] in
                                guard let self = self else { return }
                                self.subitemsLabel.text = "\(self.subitems)"
            },
                              completion: nil)
        } else {
            subitemsLabel.text = ""
        }
    }
}
