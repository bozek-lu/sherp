//
//  AppDelegate.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        PersistencyWorker.shared.save()
    }
}

