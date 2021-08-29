//
//  DetailViewMocks.swift
//  sherpTests
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit
import CoreData
@testable import sherp

final class DetailWorkerProtocolMock: DetailWorkerProtocol {
    var fetchPostReturnValue: (Result<Post, PostError>)!
    var fetchPostReceivedId: Int16?
    func fetchPost(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void) {
        fetchPostReceivedId = id
        completion(fetchPostReturnValue)
    }
    
    var loadImageReceivedURL: URL?
    var loadImageReturnImage: UIImage?
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        loadImageReceivedURL = url
        completion(loadImageReturnImage)
    }
    
    var cancelImageLoadReceivedURL: URL?
    func cancelImageLoad(for url: URL) {
        cancelImageLoadReceivedURL = url
    }
}

final class DetailViewDisplayLogicMock: DetailViewDisplayLogic {
    var displayPostDetailsReceivedValue: [Section<Header, [PhotoElement]>] = []
    var receivedPostDetailsClosure: (([Section<Header, [PhotoElement]>]) -> Void)?
    func display(postDetails: [Section<Header, [PhotoElement]>], resetOffset: Bool) {
        displayPostDetailsReceivedValue = postDetails
        receivedPostDetailsClosure?(postDetails)
    }
    
    var displayErrorReceivedMessage: String?
    func displayError(with message: String) {
        displayErrorReceivedMessage = message
    }
    
    var displayImageReceivedURL: URL?
    func displayImage(with url: URL) {
        displayImageReceivedURL = url
    }
}

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    return managedObjectContext
}
