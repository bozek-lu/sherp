//
//  MainSceneAssembly.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

final class MainSceneAssembly {
    static func getViewController() -> SplitViewController {
        let controller = SplitViewController()
        let mainView = MainViewViewController()
        let detailView = DetailViewController()
        controller.viewControllers = [mainView, detailView]
//        let apiService = RatesApiService()
//        let worker = RatesWorker(apiService: apiService)
//        let router = RatesRouter()
//        let presenter = RatesPresenter(worker: worker)
//        router.dataStore = presenter
//        router.viewController = controller
//        controller.presenter = presenter
//        controller.router = router
//        presenter.viewController = controller
        return controller
    }
}
