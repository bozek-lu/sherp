//
//  DetailViewPresenterTests.swift
//  sherpTests
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import Foundation
import XCTest
import CoreData
@testable import sherp

final class DetailViewPresenterTests: XCTestCase {
    
    private var sut: DetailViewPresenter!
    private var worker: DetailWorkerProtocolMock!
    private var viewController: DetailViewDisplayLogicMock!
    private var managedContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        managedContext = setUpInMemoryManagedObjectContext()
        worker = DetailWorkerProtocolMock()
        viewController = DetailViewDisplayLogicMock()
        sut = DetailViewPresenter(worker: worker)
        sut.viewController = viewController
    }
    
    func testLoadingPost() {
        // Given
        worker.fetchPostReturnValue = .success(preparedPost())
        
        let expectation = XCTestExpectation()
        viewController.receivedPostDetailsClosure = { postDetails in
            defer { expectation.fulfill() }
            
            // 1 post section + 5 album sections
            XCTAssert(postDetails.count == 6)
            XCTAssert(postDetails[0].headerItem.title == "testitle")
            XCTAssert(postDetails.contains(where: { $0.headerItem.title == "0" }))
            // 1 photo for each album
            XCTAssert(postDetails[4].items.count == 1)
        }
        // When
        sut.load(post: 3)
        
        // Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    private func preparedPost() -> Post {
        let post = Post(context: managedContext)
        post.id = 3
        post.title = "testitle"
        post.userId = 5
        let user = User(context: managedContext)
        user.id = 5
        (0...4).forEach {
            let album = Album(context: managedContext)
            album.id = Int16($0)
            album.title = "\($0)"
            let photo = Photo(context: managedContext)
            photo.id = Int16($0)
            photo.albumId = Int16($0)
            photo.thumbnailUrl = URL(string: "https://www.test.com/\($0)")
            album.photos = [photo]
            user.addToAlbums(album)
            album.user = user
        }
        post.user = user
        return post
    }
}
