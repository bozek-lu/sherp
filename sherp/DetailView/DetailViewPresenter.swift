//
//  DetailViewPresenter.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

protocol DetailViewBusinessLogic {
    func load(post id: Int16)
}

final class DetailViewPresenter {
    
    weak var viewController: DetailViewDisplayLogic?
    
    private let worker: DetailWorkerProtocol
    
    private var presentedElements = [PostElement]()
    
    init(worker: DetailWorkerProtocol) {
        self.worker = worker
    }
    
//    private func parse
}

extension DetailViewPresenter: DetailViewBusinessLogic {
    func load(post id: Int16) {
        worker.fetchPost(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                self.presentedElements = elements
                DispatchQueue.main.async {
                    self.viewController?.display(postDetails: elements)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.viewController?.displayError()
                }
            }
        }
    }
}
