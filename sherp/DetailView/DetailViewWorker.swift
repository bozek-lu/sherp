//
//  DetailViewWorker.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import UIKit
import Combine

protocol DetailWorkerProtocol {
    func fetchPost(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void)
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
    func cancelImageLoad(for url: URL)
}

final class DetailViewWorker {
    private let persistency: PersistencyProtocol
    private let imageLoader: ImageLoaderProtocol
    
    private var cancellables = [URL: AnyCancellable]()
    
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
        
        cancellables[url] = loading
    }
    
    func cancelImageLoad(for url: URL) {
        cancellables[url]?.cancel()
        cancellables[url] = nil
    }
}
