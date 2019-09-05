//
//  CollectionDataSource.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/2/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import UIKit

public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void
public typealias CollectionItemDeselectionHandlerType = (IndexPath) -> Void

open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate where Cell: ConfigurableCell, Provider.T == Cell.T {
    
    // MARK: - Public Properties
    public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?
    public var collectionItemDeselectionHandler: CollectionItemDeselectionHandlerType?
    
    // MARK: - Private Properties
    let provider: Provider
    let collectionView: UICollectionView
    
    // MARK: - Lifecycle
    init(collectionView: UICollectionView, provider: Provider) {
        self.collectionView = collectionView
        self.provider = provider
        super.init()
        setUp()
    }
    
    // MARK: - Delegation Setup
    private func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - UICollectionView Delegate
    public func numberOfSections(in _: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueCell(at: indexPath)
        
        let item = provider.item(at: indexPath)
        cell.configure(item)
        
        return cell
    }
    
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionItemSelectionHandler?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionItemDeselectionHandler?(indexPath)
    }
    
    open func collectionView(_: UICollectionView, viewForSupplementaryElementOfKind _: String, at _: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: .zero)
    }
}

