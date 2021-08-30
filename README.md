# sherp

## Sherpany coding challenge
- No setup needed.

## Brief description
Project was built using a lot of new iOS API's and frameworks like: `UICollectionViewDiffableDataSource` and `Combine`. That is why minimal iOS target was left as 14.5. I did not use SwiftUI because I'm not sure how long it could take to build simple Master/Detail UI with it :)

### Architecture
After considering using VIPER architecture I've decided that scenes used in this project will not have that much logic and using Presenter and Interactor would often lead to passing models between them without making any operations. 
As a final choice I used MVP
![](https://user-images.githubusercontent.com/5692182/131254059-55cda66e-301b-4b72-b8d1-e02e7997cc1e.png)

For simplicity project was separated into two scenes, one for main view (list of posts) and second for detail (post + albums)

Every Scene have it's `ViewController`, `Presenter` and `Models`. Additionally if needed I've added `Worker` to handle tasks like communicating with persistency layer and `Router` if user can navigate somewhere from this specific scene.

Scenes have their `Assembly` files that handle dependency injection and return corresponding `ViewController`

#### Networking
To handle HTTP requests I have built `HTTPClientProtocol` that declares one simple function returning `AnyPublisher<HTTPResponse, Error>`.
Second part is `URLRequestConvertible` protocol that makes usage of enums as URLRequest very easy.

#### Persistency
To handle persistency I've used  `PersistencyWorker` singleton that implements  `PersistencyProtocol` 
This worker contains two `NSManagedObjectContext`, one to handle background/more time consuming tasks and second used to read data from database.

## Requirements checklist
#### Requirements
1. ✅ Set the navigation bar title to “Challenge Accepted!”
2. ✅ Use Swift
3. ✅ Fetch the data every time the app becomes active:
Posts: http://jsonplaceholder.typicode.com/posts/ Users: http://jsonplaceholder.typicode.com/users Photos: http://jsonplaceholder.typicode.com/albums Photos: http://jsonplaceholder.typicode.com/photos
4. ✅ Persist the data in Core Data with relationships
5. ✅ Merge fetched data with persisted data, even though the returned data of the API currently
never changes. See (6).
6. ✅ Our UI has a master/detail view. The master view should always be visible and has a fixed
width (where appropriate). The detail view adapts to the space available depending on
orientation.
7. ✅ Display a table of all the posts in the master view. For each post display the entire post title
and the users email address below the title. The cell will have a variable height because of that
8. ✅ Implement swipe to delete on a post cell. Because of (4) the post will appear again after the
next fetch of the data which is expected.
9. ✅ Selecting a post (master) displays the detail to this post. The detail view consists of the post
title, post body and related albums.
10. ✅ The creator of this post has some favorite albums that we want to display along the post. An
album consists of the album title and a collection of photos that belong to the album.
11. ✅ The photos should be lazy-ly loaded when needed and cached. If the photo is in the cache it
should take that, otherwise load from web and update the photo cell.
12. ✅ In general, provide UI feedback where you see fit.
#### Bonus points
● ✅ It would be nice to be able to show/hide the photos of an album. All albums are collapsed in the default state.

● ✅ Because the collection of photos can get quite long, we would like the headers to stick to the top.

● ✅ Include a search bar to search in the master view and provide live feedback to the user while searching.

## Improvements log
- Severe bugs fixes: https://github.com/bozek-lu/sherp/pull/1
- UI/Annoying bugs fixes: https://github.com/bozek-lu/sherp/pull/2
- Documentation + harder to debug issues: https://github.com/bozek-lu/sherp/pull/3

Two elements from list were not fixed, I don't have iPad with me and I can't reproduce constraint errors. Second issue is missing loader at first fetching of posts, It is loading quite fast for me but I still can see it
![](https://user-images.githubusercontent.com/5692182/131255297-a657d3d7-4939-4dab-83ab-14d6571baa65.png)
- [ ] Several constraints errors when running on the iPad
- [ ] The spinner (loader) during initial load (i.e. while data is being fetched) isn't visible; (user is left staring at a view with "Challenge accepted" label)
