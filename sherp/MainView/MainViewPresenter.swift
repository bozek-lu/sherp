//
//  MainViewPresenter.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

protocol MainViewBusinessLogic {
    func fetchViewModels()
    func selectedPost(at row: Int)
}

final class MainViewPresenter {
    
    private let worker: MainViewWorkerProtocol
    
    weak var viewController: MainViewDisplayLogic?
    
    private var displayedPosts = [PostViewModel.Simple]()
    
    init(worker: MainViewWorkerProtocol) {
        self.worker = worker
    }
}

extension MainViewPresenter: MainViewBusinessLogic {
    func fetchViewModels() {
        worker.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                self.displayedPosts = models
                DispatchQueue.main.async {
                    self.viewController?.display(posts: models)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.viewController?.displayError()
                }
            }
        }
    }
    
    func selectedPost(at row: Int) {
        let post = displayedPosts[row]
        viewController?.openPost(with: post.id)
    }
}
