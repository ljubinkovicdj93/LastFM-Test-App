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
public typealias OnPrefetchHandlerType = ([IndexPath]) -> Void

open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching where Cell: ConfigurableCell, Provider.T == Cell.T {
    
    // MARK: - Public Properties
    public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?
    public var collectionItemDeselectionHandler: CollectionItemDeselectionHandlerType?
    public var onPrefetchHandler: OnPrefetchHandlerType?
    
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
        collectionView.prefetchDataSource = self
    }
    
    // MARK: - UICollectionView Data Source
    public func numberOfSections(in _: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueCell(at: indexPath)
        
        if let item = provider.item(at: indexPath) {
            cell.configure(item)
        }
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionItemSelectionHandler?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionItemDeselectionHandler?(indexPath)
    }
    
    open func collectionView(_: UICollectionView, viewForSupplementaryElementOfKind _: String, at _: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: .zero)
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching Delegate
    open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        onPrefetchHandler?(indexPaths)
    }
}
