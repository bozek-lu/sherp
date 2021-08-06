//
//  DetailViewWorker.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import Foundation

protocol DetailWorkerProtocol {
    func fetchPost(with id: Int16, completion: @escaping (Result<[PostElement], PostError>) -> Void)
}

final class DetailViewWorker {
    private let persistency: PersistencyProtocol
    
    init(persistency: PersistencyProtocol) {
        self.persistency = persistency
    }
    
    private func parse(model: Post) -> [PostElement] {
        [PostViewModel.Details(title: model.title ?? "--Missing title--",
                               body: model.body ?? "--Missing body--")]
    }
}

extension DetailViewWorker: DetailWorkerProtocol {
    func fetchPost(with id: Int16, completion: @escaping (Result<[PostElement], PostError>) -> Void) {
        persistency.post(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let post):
                completion(.success(self.parse(model: post)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
