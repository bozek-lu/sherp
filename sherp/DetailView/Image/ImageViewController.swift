//
//  ImageViewController.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit
import Combine

final class ImageViewController: UIViewController {
    private let imageURL: URL
    private let imageLoader: ImageLoaderProtocol
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cancellable = [AnyCancellable]()
    
    init(imageURL: URL, imageLoader: ImageLoaderProtocol) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loader.startAnimating()
        imageLoader.loadImage(from: imageURL)
            .sink { [weak self] image in
                self?.imageView.image = image
                self?.loader.stopAnimating()
            }
            .store(in: &cancellable)
    }
    
    @objc private func close() {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(loader)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        loader.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
}
