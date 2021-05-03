//
//  Globals.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 12/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewLayouts {
    
    /// 1 By 4 Mosaic layout..... This is used only in vertical directions.
    @available(iOS 13.0, *)
    static func MosaicLayout(isLandscape: Bool = true,scrollDirection direction : UICollectionView.ScrollDirection, size: CGSize) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                         heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.3))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingLeftGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let trailingRightGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let fractionalHeight = isLandscape ? NSCollectionLayoutDimension.fractionalHeight(0.6) : NSCollectionLayoutDimension.fractionalHeight(0.3)
            let groupDimensionHeight: NSCollectionLayoutDimension = fractionalHeight
            
            let rightGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [leadingItem, trailingLeftGroup, trailingRightGroup])
            
            let leftGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [trailingRightGroup, trailingLeftGroup, leadingItem])
            
            let height = isLandscape ? size.height / 0.9 : size.height / 1.25
            let megaGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(height)),
                subitems: [rightGroup, leftGroup])
            
//            let section = NSCollectionLayoutSection(group: megaGroup)
            
            let section = NSCollectionLayoutSection(group: megaGroup)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = direction
        layout.configuration = config
        
        return layout
    }
    
    /// 1 By 4 Watterfall  layout..... This is used only in vertical directions.
    @available(iOS 13.0, *)
    static func WatterFallLayout(scrollDirection direction : UICollectionView.ScrollDirection) -> UICollectionViewLayout {
        let topLeftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(0.55))
        let topLeftItem = NSCollectionLayoutItem(layoutSize: topLeftItemSize)
        topLeftItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
       
        let topLeftBottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.45))
        let topLeftBottomItem = NSCollectionLayoutItem(layoutSize: topLeftBottomItemSize)
        topLeftBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topLeftBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))

       
        let topMidItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(0.4))
        let topMidItem = NSCollectionLayoutItem(layoutSize: topMidItemSize)
        topMidItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topMidItem.edgeSpacing = .init(leading: .none, top: .fixed(24), trailing: .none, bottom: .none)
       
        let topMidBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(0.6)))
        topMidBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topMidBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
       
//        let topRightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .fractionalHeight(0.65))
//        let topRightItem = NSCollectionLayoutItem(layoutSize: topRightItemSize)
//        topRightItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
       
//        let topRightBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                                                          heightDimension: .fractionalHeight(0.35)))
//        topRightBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
//        topRightBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
       
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
       
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.5),
                                       heightDimension: .fractionalHeight(1.0)),
                                                        subitems: [topLeftItem, topLeftBottomItem])
       
        let midGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.5),
                                       heightDimension: .fractionalHeight(1.0)),
                                                        subitems: [topMidItem, topMidBottomItem])
       
//        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize:
//           NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.33),
//                                       heightDimension: .fractionalHeight(1.0)),
//                                                       subitems: [topRightItem, topRightBottomItem])
       
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftGroup, midGroup, rightGroup])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftGroup, midGroup])
       
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
           config.scrollDirection = direction
           layout.configuration = config
    
       return layout
   }
    
    @available(iOS 13.0, *)
    static func GroupCustomLayout(scrollDirection direction : UICollectionView.ScrollDirection) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.33)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                                                                  heightDimension: .fractionalHeight(1.0)),
                                                                subitem: trailingItem, count: 1)
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let twoItemGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.25)),
                subitem: item, count: 2)
            
            let centerItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)))
            centerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [twoItemGroup, centerItem, twoItemGroup])
            
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingGroup, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = direction
        layout.configuration = config
        return layout
    }
    
    
    @available(iOS 13.0, *)
    static  func MosaicReduxLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)))
            smallItem.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
        let smallItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)),subitem: smallItem, count: 2)
            
        let smallItemMegaGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),heightDimension: .fractionalHeight(1.0)),subitem: smallItemGroup, count: 2)
            
            
        let bigItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)))
            bigItem.contentInsets = .init(top: 2, leading:2, bottom: 2, trailing: 2)
        
        
        let bigItemGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),heightDimension: .fractionalHeight(1.0)),subitem: bigItem, count: 1)
            
        let topMegaGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)),subitems: [bigItemGroup, smallItemMegaGroup])
        
        let bottomMegaGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)),subitems: [smallItemMegaGroup, bigItemGroup])
            
        let gigaGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0)),subitems: [topMegaGroup, bottomMegaGroup])
            
        let section = NSCollectionLayoutSection(group: gigaGroup)
            
        return section
    }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout
    }

    
    
}
    
    
    
    

