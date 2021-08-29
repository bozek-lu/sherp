//
//  DetailViewPresenter.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit
import Combine

protocol DetailViewBusinessLogic {
    /// Starts fetching post from database and displays it.
    ///
    /// - Parameters:
    ///     - id: Identifier of post.
    func load(post id: Int16?)
    
    /// Expand or collapse album section.
    ///
    /// - Parameters:
    ///     - index: IndexPath of selected element in collection view.
    func handleExpand(on index: Int)
    
    /// When cell with image will be displayed we start loading image.
    ///
    /// - Parameters:
    ///     - index: IndexPath of image that should be loaded.
    ///     - completion: Callback with optional UIImage if loading succeeds.
    func loadImage(for index: IndexPath, completion: @escaping (UIImage?) -> Void)
    
    /// In case that image starts to load and is no longer needed
    /// we can cancel this process.
    ///
    /// - Parameters:
    ///     - url: URL that should stop loading.
    func cancelImageLoad(for url: URL?)
    
    /// Handles opening of the selected image.
    ///
    /// - Parameters:
    ///     - index: IndexPath of selected element in collection view.
    func selectedImage(at index: IndexPath)
}

final class DetailViewPresenter {
    
    weak var viewController: DetailViewDisplayLogic?
    
    private let worker: DetailWorkerProtocol
    
    private var presentedElements = [Section<Header, [PhotoElement]>]()
    
    init(worker: DetailWorkerProtocol) {
        self.worker = worker
    }
    
    private func parseToSections(_ post: Post) -> [Section<Header, [PhotoElement]>] {
        var sections = [Section<Header, [PhotoElement]>]()
        
        let detailsHeader = Header(title: post.title ?? "-- Missing title --",
                                   body: post.body ?? "-- Missing body --",
                                   isDetails: true, isExpanded: false)
        let detailSection = Section(headerItem: detailsHeader, items: [PhotoElement]())
        
        sections.append(detailSection)
        
        let albums = (post.user?.albums?.allObjects as? [Album] ?? [])
            .sorted(by: { $0.id < $1.id })
        
        sections.append(
            contentsOf: albums.map { album in
                let header = Header(title: album.title ?? "-- Missing title --", body: nil, isDetails: false, isExpanded: false)
                let photos = album.photos?.allObjects as? [Photo] ?? []
                let displayPhotos = photos.map { PhotoElement(thumbnailURL: $0.thumbnailUrl, fullURL: $0.url) }
                
                return Section(headerItem: header, items: displayPhotos)
            }
        )
        
        return sections
    }
}

extension DetailViewPresenter: DetailViewBusinessLogic {
    func load(post id: Int16?) {
        guard let id = id else {
            viewController?.displayError(with: "Post deleted\nPlease pick different one")
            return
        }
        if presentedElements.isEmpty {
            viewController?.startLoading()
        }
        worker.fetchPost(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let post):
                self.presentedElements = self.parseToSections(post)
                DispatchQueue.main.async {
                    self.viewController?.display(postDetails: self.presentedElements, resetOffset: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.viewController?.displayError(with: error.localizedDescription)
                }
            }
        }
    }
    
    func handleExpand(on index: Int) {
        presentedElements[index].headerItem.isExpanded.toggle()
        DispatchQueue.main.async {
            self.viewController?.display(postDetails: self.presentedElements, resetOffset: false)
        }
    }
    
    func loadImage(for index: IndexPath, completion: @escaping (UIImage?) -> Void) {
        guard let url = presentedElements[index.section].items[index.item].thumbnailURL else {
            completion(nil)
            return
        }
        
        worker.loadImage(for: url, completion: completion)
    }
    
    func cancelImageLoad(for url: URL?) {
        guard let url = url else { return }
        worker.cancelImageLoad(for: url)
    }
    
    func selectedImage(at index: IndexPath) {
        guard let url = presentedElements[index.section].items[index.item].fullURL else { return }
        
        viewController?.displayImage(with: url)
    }
}
