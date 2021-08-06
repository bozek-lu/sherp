//
//  PostDetailCell.swift
//  sherp
//
//  Created by Łukasz Bożek on 07/08/2021.
//

import UIKit

final class PostDetailCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
    }
    
    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    func populate(with model: PostViewModel.Details) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
    }
}
