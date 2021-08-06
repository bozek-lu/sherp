//
//  DetailViewController.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

protocol DetailViewDisplayLogic: AnyObject {
    func display(postDetails: [PostElement])
    func displayError()
}

final class DetailViewViewController: UIViewController {
    
    var presenter: DetailViewBusinessLogic?
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        view.register(PostAlbumCell.self)
        view.register(PostDetailCell.self)
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        let safe = navigationController?.view.safeAreaInsets ?? view.safeAreaInsets
        view.contentInset = .init(top: 10, left: 0, bottom: safe.bottom, right: 0)
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a post"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var postElements = [PostElement]()
    
    override func viewDidLoad() {
        setupViews()
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupConstraints()
    }
    
    private func setupViews() {
        navigationItem.title = "Challenge Accepted!"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraints() {
        emptyLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension DetailViewViewController: DetailViewDisplayLogic {
    func display(postDetails: [PostElement]) {
        loader.stopAnimating()
        tableView.isHidden = false
        emptyLabel.isHidden = true
        postElements = postDetails
        tableView.reloadData()
    }
    
    func displayError() {
        loader.stopAnimating()
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
}

extension DetailViewViewController: MainViewDelegateProtocol {
    func loadPost(with id: Int16) {
        presenter?.load(post: id)
    }
}

extension DetailViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = postElements[indexPath.row]
        let cell: PostDetailCell? = tableView.dequeue(PostDetailCell.self, for: indexPath)
        if let model = model as? PostViewModel.Details {
            cell?.populate(with: model)
        }
        return cell ?? UITableViewCell()
    }
}
