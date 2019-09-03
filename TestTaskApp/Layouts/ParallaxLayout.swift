//
//  ParallaxLayout.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/3/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

/* The heights are declared as constants outside of the class so they can be easily referenced elsewhere */
struct ParallaxLayoutConstants {
    struct Cell {
        /* The height of the non-featured cell */
        static let standardHeight: CGFloat = 100
        /* The height of the top-most visible cell */
        static let featuredHeight: CGFloat = 280
    }
}

class ParallaxLayout: UICollectionViewLayout {
    // MARK: Properties and Variables
    
    /** The amount the user needs to scroll before the featured cell changes */
    let dragOffset: CGFloat = 180.0
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    /** Returns the item index of the currently featured cell */
    var featuredItemIndex: Int {
        get {
            /* Use max to make sure the featureItemIndex is never < 0 */
            return max(0, Int(collectionView!.contentOffset.y / dragOffset))
        }
    }
    
    /** Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
        }
    }
    
    /** Returns the width of the collection view */
    var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    /** Returns the height of the collection view */
    var height: CGFloat {
        get {
            return collectionView!.bounds.height
        }
    }
    
    /** Returns the number of items in the collection view */
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    // MARK: UICollectionViewLayout
    
    /** Return the size of all the content in the collection view */
    override var collectionViewContentSize: CGSize {
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let standardHeight = ParallaxLayoutConstants.Cell.standardHeight
        let featuredHeight = ParallaxLayoutConstants.Cell.featuredHeight
        
        var frame: CGRect = .zero
        var y: CGFloat = 0.0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            /*
             We need this to guarantee that each subsequent item has a higher index than the one before it.
             As it becomes a featured cell, it will slide over the top of the previous cell.
             */
            attributes.zIndex = item
            
            var height = standardHeight
            
            if indexPath.item == featuredItemIndex {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = collectionView!.contentOffset.y - yOffset
                height = featuredHeight
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                let maxY = y + standardHeight
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            }
            frame = CGRect(x: 0.0, y: y, width: width, height: height)
            
            attributes.frame = frame
            
            cache.append(attributes)
            
            y = frame.maxY
        }
    }
    
    /** Return all attributes in the cache whose frame intersects with the rect passed to the method */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    /** Return true so that the layout is continuously invalidated as the user scrolls */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        
        return CGPoint(x: 0, y: yOffset)
    }
}