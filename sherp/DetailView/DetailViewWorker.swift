//
//  DetailViewWorker.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import UIKit
import Combine

protocol DetailWorkerProtocol {
    /// Fetch post from database.
    ///
    /// - Parameters:
    ///     - id: Identifier of post that will be fetched.
    ///     - completion: Callback with result.
    /// - Returns: Post model or error.
    func fetchPost(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void)
    
    /// Start fetching image from URL.
    ///
    /// - Parameters:
    ///     - url: Image URL.
    ///     - completion: Callback with result.
    /// - Returns: Optional UIImage.
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
    
    /// Stop fetching image.
    ///
    /// - Parameters:
    ///     - url: Image URL.
    func cancelImageLoad(for url: URL)
}

final class DetailViewWorker {
    private let persistency: PersistencyProtocol
    private let imageLoader: ImageLoaderProtocol
    
    /// Dictionary of URL's and corresponding fetching tasks
    /// Task can be cancelled and Image fetching stopped.
    private var cancellable = [URL: AnyCancellable]()
    
    init(persistency: PersistencyProtocol, imageLoader: ImageLoaderProtocol) {
        self.persistency = persistency
        self.imageLoader = imageLoader
    }
}

extension DetailViewWorker: DetailWorkerProtocol {
    func fetchPost(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void) {
        persistency.post(with: id) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let loading = imageLoader.loadImage(from: url)
            .sink { image in
                completion(image)
            }
        
        cancellable[url] = loading
    }
    
    func cancelImageLoad(for url: URL) {
        cancellable[url]?.cancel()
        cancellable[url] = nil
    }
}
