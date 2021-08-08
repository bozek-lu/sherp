//
//  PostAlbumHeader.swift
//  sherp
//
//  Created by Łukasz Bożek on 07/08/2021.
//

import UIKit

protocol PostAlbumHeaderDelegate: AnyObject {
    func expand(header: PostAlbumHeader, section: Int)
}

final class PostAlbumHeader: UICollectionReusableView {
    
    weak var delegate: PostAlbumHeaderDelegate?
    private var section = 0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "chevron")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isExpanded = false
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTapped))
        addGestureRecognizer(tap)
        
        backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    func populate(with model: Header, section: Int) {
        self.section = section
        isExpanded = model.isExpanded
        expandImage.transform = model.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        titleLabel.text = model.title
    }
    
    @objc private func expandTapped() {
        UIView.animate(withDuration: 0.3) {
            self.expandImage.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        delegate?.expand(header: self, section: section)
    }
}

extension PostAlbumHeader {
    private func setupViews() {
        addSubview(expandImage)
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        expandImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        expandImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        expandImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        expandImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: expandImage.leadingAnchor, constant: -10).isActive = true
    }
}
