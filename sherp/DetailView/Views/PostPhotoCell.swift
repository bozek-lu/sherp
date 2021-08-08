//
//  PostPhotoCell.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit

final class PostPhotoCell: UICollectionViewCell {
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView = UIImageView()
    
    var onReuse: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with model: PhotoElement) {
        loader.startAnimating()
    }
    
    func display(image: UIImage?) {
        loader.stopAnimating()
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        imageView.image = nil
    }
}

extension PostPhotoCell {
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loader)
    }
    
    private func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        loader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
