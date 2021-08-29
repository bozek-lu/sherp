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
    func deletePost(at row: Int)
}

final class MainViewPresenter {
    
    private let worker: MainViewWorkerProtocol
    
    weak var viewController: MainViewDisplayLogic?
    
    private var filterString = ""
    private var displayedPosts = [MainViewModels.Post]()
    private var filteredPosts = [MainViewModels.Post]()
    private var selectedPostId: Int16?
    
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
    
    private func post(at row: Int) -> MainViewModels.Post {
        filterString.isEmpty ? displayedPosts[row] : filteredPosts[row]
    }
    
    private func removePost(with id: Int16, from posts: inout [MainViewModels.Post]) {
        if let filteredIndex = posts.firstIndex(where: { $0.id == id }) {
            posts.remove(at: filteredIndex)
        }
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
        let postId = post(at: row).id
        viewController?.openPost(with: postId)
        selectedPostId = postId
    }
    
    func searchDidChange(string: String) {
        filterString = string
        updateResults()
    }
    
    func deletePost(at row: Int) {
        let postId = post(at: row).id
        worker.removePost(with: postId)
        removePost(with: postId, from: &displayedPosts)
        removePost(with: postId, from: &filteredPosts)
        
        if postId == selectedPostId {
            viewController?.removePostSelection()
            selectedPostId = nil
        }
    }
}
