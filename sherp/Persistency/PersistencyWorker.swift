//
//  PersistencyWorker.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import Foundation
import CoreData

protocol PersistencyProtocol {
    func save()
    func post(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void)
    func saveAndMerge(posts: [PostModel], users: [UserModel],
                      albums: [AlbumModel], photos: [PhotoModel])
}

final class PersistencyWorker {
    static let shared: PersistencyProtocol = PersistencyWorker()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "sherp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // Merge policy is set to prefer store version over in-memory version (since context is read-only).
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        
        return persistentContainer.viewContext
    }()
    
    /// Background context to perform long/write operations.
    /// Context saves immediately propagate changes to the persistent store.
    private lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        
        // Merge operations should occur on a property basis (`id` attribute)
        // and the in memory version “wins” over the persisted one.
        // All entities have been modeled with an `id` constraint.
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        return context
    }()
    
}

extension PersistencyWorker: PersistencyProtocol {
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func post(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void) {
        managedObjectContext.perform {
            // setup fetch request
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", id)
            //  -> pre-fetching avoiding multiple fault fires
//            fetchRequest.relationshipKeyPathsForPrefetching = ["user.albums.photos"]
            fetchRequest.fetchLimit = 1
            
            do {
                guard let managed = try self.managedObjectContext.fetch(fetchRequest).first else {
                    completion(.failure(.dbFail))
                    return
                }
                completion(.success(managed))
            } catch {
                completion(.failure(.dbFail))
                print("Failed to get post with error: \(error)")
            }
        }
    }
    
    func saveAndMerge(posts: [PostModel], users: [UserModel],
                      albums: [AlbumModel], photos: [PhotoModel]) {
        let managedPhotos = createPhotos(with: photos)
        let managedAlbums = createAlbums(with: albums, photos: managedPhotos)
        let managedUsers = createUsers(with: users, albums: managedAlbums)
        createPosts(with: posts, users: managedUsers)
    }
    
    private func createUsers(with users: [UserModel], albums: [Album]) -> [User] {
        users.map { usr in
            let user = User(context: backgroundManagedObjectContext)
            user.email = usr.email
            user.id = usr.id
            user.name = usr.name
            user.username = usr.username
            let userAlbums = albums.filter { $0.userId == usr.id }
            userAlbums.forEach {
                user.addToAlbums($0)
                $0.user = user
            }
            return user
        }
    }
    
    private func createPhotos(with photos: [PhotoModel]) -> [Photo] {
        photos.map {
            let photo = Photo(context: backgroundManagedObjectContext)
            photo.albumId = $0.albumId
            photo.id = $0.id
            photo.title = $0.title
            photo.thumbnailUrl = $0.thumbnailUrl
            photo.url = $0.url
            return photo
        }
    }
    
    private func createAlbums(with albums: [AlbumModel], photos: [Photo]) -> [Album] {
        albums.map { alb in
            let album = Album(context: backgroundManagedObjectContext)
            album.id = alb.id
            album.userId = alb.userId
            album.title = alb.title
            let albumPhotos = photos.filter { alb.id == $0.albumId }
            albumPhotos.forEach {
                album.addToPhotos($0)
                $0.album = album
            }
            return album
        }
    }
    
    @discardableResult
    private func createPosts(with posts: [PostModel], users: [User]) -> [Post] {
        posts.map { pst in
            let post = Post(context: backgroundManagedObjectContext)
            post.id = pst.id
            post.title = pst.title
            post.body = pst.body
            post.userId = pst.userId
            post.user = users.first { $0.id == post.userId }
            return post
        }
    }
}
