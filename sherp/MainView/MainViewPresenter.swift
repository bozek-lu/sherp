//
//  MainViewPresenter.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

protocol MainViewBusinessLogic {
    /// Starts process of fetching ViewModels that will be displayed.
    /// On success: fetched models are displayed, search is cleared
    /// and if post was selected it will be selected again
    func fetchViewModels()
    
    /// Sets selected post ID and opens that post
    ///
    /// - Parameters:
    ///     - row: The *row* that was tapped in table view.
    func selectedPost(at row: Int)
    
    /// Used when something was typed in search bar
    ///
    /// - Parameters:
    ///     - string: String was typed in search bar.
    func searchDidChange(string: String)
    
    /// Deleting post was triggered
    ///
    /// - Parameters:
    ///     - row: The *row* that was removed in table view.
    func deletePost(at row: Int)
}

final class MainViewPresenter {
    
    private let worker: MainViewWorkerProtocol
    
    weak var viewController: MainViewDisplayLogic?
    
    ///
    private var filterString = ""
    private var displayedPosts = [MainViewModels.Post]()
    private var filteredPosts = [MainViewModels.Post]()
    private var selectedPostId: Int16?
    
    init(worker: MainViewWorkerProtocol) {
        self.worker = worker
    }
    
    private func updateResults() {
        // If search string is empty we should end filtering results
        // In case that any post was selected try to re-select it
        if filterString.isEmpty {
            viewController?.display(posts: displayedPosts)
            reSelectPostIfNeeded()
            return
        }
        
        filteredPosts = displayedPosts.filter {
            $0.title.lowercased().contains(filterString.lowercased())
        }
        
        // Displaying empty state message if results list is empty
        filteredPosts.isEmpty
            ? viewController?.displayError(with: "No posts for phrase:\n\"\(filterString)\"")
            : viewController?.display(posts: filteredPosts)
    }
    
    private func post(at row: Int) -> MainViewModels.Post {
        filterString.isEmpty ? displayedPosts[row] : filteredPosts[row]
    }
    
    private func removePost(with id: Int16, from posts: inout [MainViewModels.Post]) {
        if let filteredIndex = posts.firstIndex(where: { $0.id == id }) {
            posts.remove(at: filteredIndex)
        }
    }
    
    private func reSelectPostIfNeeded() {
        guard let postId = self.selectedPostId,
              let index = displayedPosts.firstIndex(where: { $0.id == postId }) else {
            return
        }
        
        viewController?.restoreSelection(at: IndexPath(row: index, section: 0))
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
                    self.viewController?.resetSearch()
                    self.reSelectPostIfNeeded()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.viewController?.displayError(with: "Failed to fetch")
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
