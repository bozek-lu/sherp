//
//  PostAlbumCell.swift
//  sherp
//
//  Created by Łukasz Bożek on 07/08/2021.
//

import UIKit

final class PostAlbumCell: UITableViewCell {
    
    private lazy var container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView()
        
        return collection
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    init(frame: CGRect) {
        super.init(style: .default, reuseIdentifier: "TagAricleCell")
        self.frame = frame
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(container)
    }
    
    private func setupConstraints() {
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
}
