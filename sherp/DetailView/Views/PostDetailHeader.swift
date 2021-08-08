//
//  PostDetailHeader.swift
//  sherp
//
//  Created by Łukasz Bożek on 07/08/2021.
//

import UIKit

final class PostDetailHeader: UICollectionReusableView {
    
    private lazy var titleDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.numberOfLines = 0
        label.text = "Post title:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bodyDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.numberOfLines = 0
        label.text = "Post body:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func populate(with model: Header) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
    }
}

extension PostDetailHeader {
    private func setupViews() {
        addSubview(titleDescription)
        addSubview(titleLabel)
        addSubview(bodyDescription)
        addSubview(bodyLabel)
    }
    
    private func setupConstraints() {
        titleDescription.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: titleDescription.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        bodyDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        bodyDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        bodyDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: bodyDescription.bottomAnchor, constant: 5).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        let bodyToBottom = bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        // Some titles are bigger than estimated value
        // to avoid constraints errors priority is changed
        bodyToBottom.priority = .defaultHigh
        bodyToBottom.isActive = true
    }
}
