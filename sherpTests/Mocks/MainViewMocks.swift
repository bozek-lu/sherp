//
//  MainViewMocks.swift
//  sherpTests
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import Foundation
@testable import sherp

final class MainViewWorkerProtocolMock: MainViewWorkerProtocol {
    var fetchDataCallsCount = 0
    var fetchDataReturn: Result<[MainViewModels.Post], PostError>!
    func fetchData(completion: @escaping (Result<[MainViewModels.Post], PostError>) -> Void) {
        fetchDataCallsCount += 1
        completion(fetchDataReturn)
    }
    
    public var removePostReceivedId: Int16?
    func removePost(with id: Int16) {
        removePostReceivedId = id
    }
}

final class MainViewDisplayLogicMock: MainViewDisplayLogic {
    var displayPostsReceived: [MainViewModels.Post]?
    var receivedPostsClosure: (([MainViewModels.Post]) -> Void)?
    func display(posts: [MainViewModels.Post]) {
        displayPostsReceived = posts
        receivedPostsClosure?(posts)
    }
    
    var displayErrorCallsCount = 0
    func displayError() {
        displayErrorCallsCount += 1
    }
    
    var openPostReceivedID: Int16?
    func openPost(with id: Int16) {
        openPostReceivedID = id
    }
}
