//
//  MainViewViewController.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

protocol MainViewDisplayLogic: AnyObject {
    func display(posts: [MainViewModels.Post])
    func displayError()
    func openPost(with id: Int16)
    func removePostSelection()
}

enum ViewState {
    case loading
    case error
    case data
}

protocol MainViewDelegateProtocol: AnyObject {
    func loadPost(with id: Int16?)
}

final class MainViewViewController: UIViewController {
    weak var delegate: MainViewDelegateProtocol?
    
    var presenter: MainViewBusinessLogic?
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.searchTextField.leftView?.tintColor = .white
        bar.searchTextField.textColor = .white
        bar.searchTextField.placeholder = "Search posts..."
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: [.editingChanged, .valueChanged])
        bar.searchTextField.delegate = self
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.keyboardDismissMode = .onDrag
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 55
        view.allowsSelectionDuringEditing = true
        view.register(PostCell.self)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        let safe = navigationController?.view.safeAreaInsets ?? view.safeAreaInsets
        view.contentInset = .init(top: 10, left: 0, bottom: safe.bottom, right: 0)
        return view
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to load posts"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var postModels = [MainViewModels.Post]()
    
    private var viewState = ViewState.loading {
        didSet {
            switch viewState {
            case .data:
                tableView.isHidden = false
                searchBar.isHidden = false
                emptyLabel.isHidden = true
                loader.stopAnimating()
            case .error:
                tableView.isHidden = true
                searchBar.isHidden = true
                emptyLabel.isHidden = false
                loader.stopAnimating()
            case .loading:
                tableView.isHidden = true
                searchBar.isHidden = true
                emptyLabel.isHidden = true
                loader.startAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        setupViews()
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        viewState = .loading
        presenter?.fetchViewModels()
        
        setupObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        navigationItem.title = "Challenge Accepted!"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        view.addSubview(emptyLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loader)
    }
    
    private func setupConstraints() {
        emptyLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appBecomeActive() {
        presenter?.fetchViewModels()
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        presenter?.searchDidChange(string: textField.text ?? "")
    }
}

extension MainViewViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.searchDidChange(string: textField.text ?? "")
        return true
    }
}

extension MainViewViewController: MainViewDisplayLogic {
    func display(posts: [MainViewModels.Post]) {
        postModels = posts
        tableView.reloadData()
        viewState = .data
    }
    
    func displayError() {
        viewState = .error
    }
    
    func openPost(with id: Int16) {
        guard let vc = delegate as? UIViewController else { return }
        showDetailViewController(vc, sender: false)
        delegate?.loadPost(with: id)
    }
    
    func removePostSelection() {
        delegate?.loadPost(with: nil)
    }
}

extension MainViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectedPost(at: indexPath.row)
    }
}

extension MainViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = postModels[indexPath.row]
        let cell = tableView.dequeue(PostCell.self, for: indexPath)
        cell?.populate(with: model)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            postModels.remove(at: indexPath.row)
            presenter?.deletePost(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
