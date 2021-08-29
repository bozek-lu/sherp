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
    func removePost(with id: Int16)
    func saveAndMerge(posts: [PostModel], users: [UserModel],
                      albums: [AlbumModel], photos: [PhotoModel])
    func getAllPosts(completion: @escaping (Result<[Post], PostError>) -> Void)
}

final class PersistencyWorker {
    static let shared: PersistencyProtocol = PersistencyWorker()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "sherp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // Overwriting completely with new models
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.overwrite
        
        return persistentContainer.viewContext
    }()
    
    // Background context to perform longer tasks and not block user UI
    // like saving all models from web
    private lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        
        // Overwriting completely with new models
        context.mergePolicy = NSMergePolicy.overwrite
        
        return context
    }()
    
    private func createUsers(with users: [UserModel], albums: [Album], in context: NSManagedObjectContext) -> [User] {
        users.map { usr in
            let user = User(context: context)
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
    
    private func createPhotos(with photos: [PhotoModel], in context: NSManagedObjectContext) -> [Photo] {
        photos.map {
            let photo = Photo(context: context)
            photo.albumId = $0.albumId
            photo.id = $0.id
            photo.title = $0.title
            photo.thumbnailUrl = $0.thumbnailUrl
            photo.url = $0.url
            return photo
        }
    }
    
    private func createAlbums(with albums: [AlbumModel], photos: [Photo], in context: NSManagedObjectContext) -> [Album] {
        albums.map { alb in
            let album = Album(context: context)
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
    private func createPosts(with posts: [PostModel], users: [User], in context: NSManagedObjectContext) -> [Post] {
        posts.map { pst in
            let post = Post(context: context)
            post.id = pst.id
            post.title = pst.title
            post.body = pst.body
            post.userId = pst.userId
            post.user = users.first { $0.id == post.userId }
            return post
        }
    }
}

extension PersistencyWorker: PersistencyProtocol {
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func post(with id: Int16, completion: @escaping (Result<Post, PostError>) -> Void) {
        let context = managedObjectContext
        context.perform {
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", id)
            fetchRequest.fetchLimit = 1
            
            do {
                guard let managed = try context.fetch(fetchRequest).first else {
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
    
    func removePost(with id: Int16) {
        let context = managedObjectContext
        context.perform {
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", id)
            fetchRequest.fetchLimit = 1
            
            do {
                guard let object = try context.fetch(fetchRequest).first else {
                    return
                }
                context.delete(object)
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Failed to remove post with error: \(error)")
            }
        }
    }
    
    func saveAndMerge(posts: [PostModel], users: [UserModel],
                      albums: [AlbumModel], photos: [PhotoModel]) {
        let context = backgroundManagedObjectContext
        context.perform { [weak self] in
            guard let self = self else { return }
            let managedPhotos = self.createPhotos(with: photos, in: context)
            let managedAlbums = self.createAlbums(with: albums, photos: managedPhotos, in: context)
            let managedUsers = self.createUsers(with: users, albums: managedAlbums, in: context)
            self.createPosts(with: posts, users: managedUsers, in: context)
            
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Failed to save to Core Data: \(error).")
            }
        }
    }
    
    func getAllPosts(completion: @escaping (Result<[Post], PostError>) -> Void) {
        let context = managedObjectContext
        context.perform {
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            
            do {
                let managed = try context.fetch(fetchRequest)
                completion(managed.isEmpty ? .failure(.dbFail) : .success(managed))
            } catch {
                completion(.failure(.dbFail))
                print("Failed to get post with error: \(error)")
            }
        }
    }
}
