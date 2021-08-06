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
    func searchDidChange(string: String)
}

final class MainViewPresenter {
    
    private let worker: MainViewWorkerProtocol
    
    weak var viewController: MainViewDisplayLogic?
    
    private var filterString = ""
    private var displayedPosts = [PostViewModel.Simple]()
    private var filteredPosts = [PostViewModel.Simple]()
    
    init(worker: MainViewWorkerProtocol) {
        self.worker = worker
    }
    
    private func updateResults() {
        if filterString.isEmpty {
            viewController?.display(posts: displayedPosts)
            return
        }
        
        filteredPosts = displayedPosts.filter {
            $0.title.lowercased().contains(filterString.lowercased())
        }
        
        viewController?.display(posts: filteredPosts)
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
        let post: PostViewModel.Simple
        if filterString.isEmpty {
            post = displayedPosts[row]
        } else {
            post = filteredPosts[row]
        }
        viewController?.openPost(with: post.id)
    }
    
    func searchDidChange(string: String) {
        filterString = string
        updateResults()
    }
}
