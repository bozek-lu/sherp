//
//  MainViewWorker.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation
import Combine

protocol MainViewWorkerProtocol {
    func fetchData(completion: @escaping (Result<[MainViewModels.Post], PostError>) -> Void)
    func removePost(with id: Int16)
}

final class MainViewWorker {
    
    private let httpClient: HTTPClientProtocol
    private let persistencyWorker: PersistencyProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(httpClient: HTTPClientProtocol, persistencyWorker: PersistencyProtocol) {
        self.httpClient = httpClient
        self.persistencyWorker = persistencyWorker
    }
    
    private func fetchPosts() -> AnyPublisher<[PostModel], Never> {
        fetch(for: .posts)
    }
    
    private func fetchUsers() -> AnyPublisher<[UserModel], Never> {
        fetch(for: .users)
    }
    
    private func fetchAlbums() -> AnyPublisher<[AlbumModel], Never> {
        fetch(for: .albums)
    }
    
    private func fetchPhotos() -> AnyPublisher<[PhotoModel], Never> {
        fetch(for: .photos)
    }
    
    private func fetch<T: Decodable>(for request: SherpRequest) -> AnyPublisher<[T], Never> {
        httpClient.httpTask(with: request)
            .map { $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .replaceError(with: [T]())
            .eraseToAnyPublisher()
    }
    
    private func combine(posts: [PostModel], users: [UserModel],
                         albums: [AlbumModel], photos: [PhotoModel],
                         completion: (Result<[MainViewModels.Post], PostError>) -> Void) {
        let posts: [PostModel] = posts.map {
            var post = $0
            post.user = users.first(where: { $0.id == post.userId })
            return post
        }
        let postModels = posts.map {
            MainViewModels.Post(id: $0.id, title: $0.title ?? "-- Missing title --",
                                email: $0.user?.email ?? "-- Missing email --")
        }
        completion(postModels.isEmpty ? .failure(.fetchingFail) : .success(postModels))
        persistencyWorker.saveAndMerge(posts: posts, users: users,
                                       albums: albums, photos: photos)
    }
}

extension MainViewWorker: MainViewWorkerProtocol {
    func fetchData(completion: @escaping (Result<[MainViewModels.Post], PostError>) -> Void) {
        Publishers.Zip4(fetchPosts(), fetchUsers(), fetchAlbums(), fetchPhotos())
            .sink(receiveValue: { [weak self] (posts, users, albums, photos) in
                self?.combine(posts: posts, users: users,
                              albums: albums, photos: photos,
                              completion: completion)
            })
            .store(in: &cancellables)
    }
    
    func removePost(with id: Int16) {
        persistencyWorker.removePost(with: id)
    }
}
