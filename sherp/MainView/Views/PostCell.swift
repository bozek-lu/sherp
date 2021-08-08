//
//  PostCell.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import UIKit

final class PostCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    init(frame: CGRect) {
        super.init(style: .default, reuseIdentifier: "PostCell")
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
    
    func populate(with model: MainViewModels.Post) {
        titleLabel.text = model.title
        emailLabel.text = model.email
    }
}

extension PostCell {
    private func setupViews() {
        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray
        selectedBackgroundView = selectedView
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)
    }
    
    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        let emailToBottom = emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        // Some titles are bigger than estimated value
        // to avoid constraints errors priority is changed
        emailToBottom.priority = .defaultHigh
        emailToBottom.isActive = true
    }
}
