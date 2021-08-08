//
//  MainViewPresenterTests.swift
//  sherpTests
//
//  Created by Łukasz Bożek on 08/08/2021.
//


import XCTest
@testable import sherp

class MainViewPresenterTests: XCTestCase {
    
    private var sut: MainViewPresenter!
    private var worker: MainViewWorkerProtocolMock!
    private var viewController: MainViewDisplayLogicMock!

    override func setUp() {
        super.setUp()
        worker = MainViewWorkerProtocolMock()
        viewController = MainViewDisplayLogicMock()
        sut = MainViewPresenter(worker: worker)
        sut.viewController = viewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchingData() {
        // Given
        worker.fetchDataReturn = .success(Seeds.mainPosts())
        let expectation = XCTestExpectation()
        viewController.receivedPostsClosure = { posts in
            defer { expectation.fulfill() }
            
            XCTAssert(posts.count == 5)
            XCTAssert(posts.contains(where: { $0.id == 1 }))
        }
        // When
        sut.fetchViewModels()
        
        // Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testSelectingPost() {
        // Given
        worker.fetchDataReturn = .success(Seeds.mainPosts())
        sut.fetchViewModels()
        
        // When
        sut.selectedPost(at: 1)
        
        // Then
        XCTAssert(viewController.openPostReceivedID == 2)
    }
    
    func testRemovingPost() {
        // Given
        worker.fetchDataReturn = .success(Seeds.mainPosts())
        sut.fetchViewModels()
        
        // When
        sut.deletePost(at: 2)
        
        // Then
        XCTAssert(worker.removePostReceivedId == 3)
    }
    
    func testSearch() {
        // Given
        worker.fetchDataReturn = .success(Seeds.mainPosts())
        sut.fetchViewModels()
        
        // When
        sut.searchDidChange(string: "eSt 3")
        
        // Then
        XCTAssert(viewController.displayPostsReceived?.count == 1)
    }
    
    func testShouldRemoveCorrectPostFromFilteredList() {
        // Given
        worker.fetchDataReturn = .success(Seeds.mainPosts())
        sut.fetchViewModels()
        sut.searchDidChange(string: "eSt 4")
        
        // When
        sut.deletePost(at: 0)
        
        // Then
        XCTAssert(worker.removePostReceivedId  == 4)
    }
}
