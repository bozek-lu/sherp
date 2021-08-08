//
//  DetailViewAssembly.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

final class DetailViewAssembly {
    static func getViewController() -> DetailViewViewController {
        let controller = DetailViewViewController()
        let worker = DetailViewWorker(persistency: PersistencyWorker.shared, imageLoader: ImageLoader.shared)
        let presenter = DetailViewPresenter(worker: worker)

        controller.presenter = presenter
        presenter.viewController = controller
        
        return controller
    }
}
