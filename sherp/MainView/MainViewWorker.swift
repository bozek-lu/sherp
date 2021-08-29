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
    
    private var cancellable = [AnyCancellable]()
    
    init(httpClient: HTTPClientProtocol, persistencyWorker: PersistencyProtocol) {
        self.httpClient = httpClient
        self.persistencyWorker = persistencyWorker
    }
    
    private func fetchPosts() -> AnyPublisher<[PostModel], Never> {
        fetch(.posts)
    }
    
    private func fetchUsers() -> AnyPublisher<[UserModel], Never> {
        fetch(.users)
    }
    
    private func fetchAlbums() -> AnyPublisher<[AlbumModel], Never> {
        fetch(.albums)
    }
    
    private func fetchPhotos() -> AnyPublisher<[PhotoModel], Never> {
        fetch(.photos)
    }
    
    private func fetch<T: Decodable>(_ request: SherpRequest) -> AnyPublisher<[T], Never> {
        httpClient.httpTask(with: request)
            .map { $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .replaceError(with: [T]())
            .eraseToAnyPublisher()
    }
    
    private func combine(posts: [PostModel], users: [UserModel],
                         albums: [AlbumModel], photos: [PhotoModel],
                         completion: @escaping (Result<[MainViewModels.Post], PostError>) -> Void) {
        let posts: [PostModel] = posts.map {
            var post = $0
            post.user = users.first(where: { $0.id == post.userId })
            return post
        }.sorted(by: { $0.id < $1.id })
        let postModels = mapToViewModels(posts: posts)
        if postModels.isEmpty {
            getPersistedPosts(completion: completion)
        } else {
            completion(.success(postModels))
            persistencyWorker.saveAndMerge(posts: posts, users: users,
                                           albums: albums, photos: photos)
        }
    }
    
    private func mapToViewModels(posts: [PostModel]) -> [MainViewModels.Post] {
        posts.map {
            MainViewModels.Post(id: $0.id, title: $0.title ?? "-- Missing title --",
                                email: $0.user?.email ?? "-- Missing email --")
        }
    }
    
    private func getPersistedPosts(completion: @escaping (Result<[MainViewModels.Post], PostError>) -> Void) {
        persistencyWorker.getAllPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let posts):
                let postModels = posts.map { PostModel(from: $0) }.sorted(by: { $0.id < $1.id })
                let viewModels = self.mapToViewModels(posts: postModels)
                completion(postModels.isEmpty ? .failure(.fetchingFail) : .success(viewModels))
            }
        }
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
            .store(in: &cancellable)
    }
    
    func removePost(with id: Int16) {
        persistencyWorker.removePost(with: id)
    }
}
