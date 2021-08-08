//
//  ImageLoader.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit
import Combine

protocol ImageLoaderProtocol {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class ImageLoader: ImageLoaderProtocol {
    
    static let shared = ImageLoader(cache: ImageCache())
    private let cache: ImageCacheProtocol
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 20
        return queue
    }()
    
    init(cache: ImageCacheProtocol) {
        self.cache = cache
    }

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { [unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
