//
//  ImageCache.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit

protocol ImageCacheProtocol: AnyObject {
    /// Get image from cache using it's URL.
    ///
    /// - Parameters:
    ///     - url: URL used to find image cache.
    /// - Returns: Optional UIImage
    func image(for url: URL) -> UIImage?
    
    /// Save UIImage in cache using it's URL as a key.
    ///
    /// - Parameters:
    ///     - image: UIImage that will be saved.
    ///     - url: Image URL.
    func insertImage(_ image: UIImage?, for url: URL)
    
    /// Remove image with specified URL from cache.
    ///
    /// - Parameters:
    ///     - url: URL used to find image cache.
    func removeImage(for url: URL)
    
    /// Clear all images cache.
    func removeAllImages()
    
    /// Subscript object to get access to cache.
    ///
    /// - Parameters:
    ///     - url: URL used to find image cache.
    /// - Returns: Optional UIImage
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCache {

    // cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache {
    func image(for url: URL) -> UIImage? {
        // search for image data
        imageCache.object(forKey: url as AnyObject) as? UIImage
    }
}

extension ImageCache: ImageCacheProtocol {
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }

        imageCache.setObject(image, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        imageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImages() {
        imageCache.removeAllObjects()
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}
