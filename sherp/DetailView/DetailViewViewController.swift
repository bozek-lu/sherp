//
//  DetailViewController.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

protocol DetailViewDisplayLogic: AnyObject {
    func display(postDetails: [Section<Header, [PhotoElement]>], resetOffset: Bool)
    func displayError(with message: String)
    func displayImage(with url: URL)
    func startLoading()
}

final class DetailViewViewController: UIViewController {
    
    var presenter: DetailViewBusinessLogic?
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(65))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.mainSection
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostAlbumHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView.register(PostDetailHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView.register(PostPhotoCell.self)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var collectionDataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, _) in
        guard let self = self, let cell = collectionView.dequeue(PostPhotoCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        let section = self.postElements[indexPath.section]
        let model = section.items[indexPath.item]
        cell.populate(with: model)
        
        self.presenter?.loadImage(for: indexPath, completion: { image in
            cell.display(image: image)
        })
        
        cell.onReuse = { [weak self] in
            self?.presenter?.cancelImageLoad(for: model.thumbnailURL)
        }
        
        return cell
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a post"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var postElements = [Section<Header, [PhotoElement]>]()
    
    override func viewDidLoad() {
        setupHeaderProvider()
        setupViews()
        super.viewDidLoad()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationItem.title = "Challenge Accepted!"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(collectionView)
        view.addSubview(messageLabel)
        view.addSubview(loader)
    }
    
    private func setupHeaderProvider() {
        collectionDataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView,
                                                                        kind: String,
                                                                        indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let model = self.postElements[indexPath.section].headerItem
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeue(PostDetailHeader.self, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
                header?.populate(with: model)
                return header
            default:
                let header = collectionView.dequeue(PostAlbumHeader.self, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
                header?.populate(with: model, section: indexPath.section)
                header?.delegate = self
                return header
            }
        }
    }
    
    private func setupConstraints() {
        messageLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section<Header, [PhotoElement]>, PhotoElement>()
        postElements.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.headerItem.isExpanded ? $0.items : [])
        }
        collectionDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DetailViewViewController: DetailViewDisplayLogic {
    func display(postDetails: [Section<Header, [PhotoElement]>], resetOffset: Bool) {
        loader.stopAnimating()
        collectionView.isHidden = false
        messageLabel.isHidden = true
        postElements = postDetails
        reloadData()
        if resetOffset {
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    func displayError(with message: String) {
        loader.stopAnimating()
        collectionView.isHidden = true
        messageLabel.text = message
        messageLabel.isHidden = false
    }
    
    func displayImage(with url: URL) {
        let imageController = ImageViewController(imageURL: url, imageLoader: ImageLoader.shared)
        
        if let navController = navigationController {
            navController.pushViewController(imageController, animated: true)
        } else {
            present(imageController, animated: true, completion: nil)
        }
    }
    
    func startLoading() {
        collectionView.isHidden = true
        messageLabel.isHidden = true
        loader.startAnimating()
    }
}

extension DetailViewViewController: MainViewDelegateProtocol {
    func loadPost(with id: Int16?) {
        presenter?.load(post: id)
    }
}

extension DetailViewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectedImage(at: indexPath)
    }
}

extension DetailViewViewController: PostAlbumHeaderDelegate {
    func expand(header: PostAlbumHeader, section: Int) {
        presenter?.handleExpand(on: section)
    }
}
