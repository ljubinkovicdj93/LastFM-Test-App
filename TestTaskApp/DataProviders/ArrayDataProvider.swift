//
//  ArrayDataProvider.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

public class ArrayDataProvider<T>: CollectionDataProvider {
    // MARK: - Internal Properties
    var items: [[T]] = []
    
    // MARK: - Lifecycle
    init(array: [[T]]) {
        items = array
    }
    
    // MARK: - Collection Data Provider
    public func numberOfSections() -> Int {
        guard items.count > 0 else { return 1 }
        
        return items.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        if items.count == 0 {
            return 1
        } else {
            return items[section].count
        }
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        guard indexPath.section >= 0,
            indexPath.section < items.count,
            indexPath.row >= 0,
            indexPath.row < items[indexPath.section].count
            else {
                return nil
        }
        
        return items[indexPath.section][indexPath.row]
    }
    
    public func updateItem(at indexPath: IndexPath, value: T) {
        guard indexPath.section >= 0,
            indexPath.section < items.count,
            indexPath.row >= 0,
            indexPath.row < items[indexPath.section].count
            else {
                return
        }
        
        items[indexPath.section][indexPath.row] = value
    }
    
    public func addItems(values: [T]) {
        items.append(values)
    }
    
    public func removeItems() {
        items = []
    }
}
