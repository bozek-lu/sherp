//
//  MainViewAssembly.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

final class MainViewAssembly {
    static func getViewController() -> MainViewViewController {
        let controller = MainViewViewController()
        let worker = MainViewWorker(httpClient: HTTPClient(),
                                    persistencyWorker: PersistencyWorker.shared)
        let presenter = MainViewPresenter(worker: worker)
        
        controller.presenter = presenter
        presenter.viewController = controller
        
        return controller
    }
}
