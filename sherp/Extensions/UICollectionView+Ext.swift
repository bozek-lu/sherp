//
//  UICollectionView+Ext.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    public func dequeue<T: AnyObject>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T
    }
    
    public func register<T: UICollectionReusableView>(_ viewClass: T.Type, kind: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: viewClass))
    }

    public func dequeue<T: UICollectionReusableView>(_ viewClass: T.Type, kind: String, for indexPath: IndexPath) -> T? {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: viewClass), for: indexPath) as? T
    }
}
