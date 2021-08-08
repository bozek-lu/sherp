//
//  MainSceneAssembly.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

final class MainSceneAssembly {
    static func getViewController() -> UIViewController {
        let controller = SplitViewController()
        let mainView = MainViewAssembly.getViewController()
        let detailView = DetailViewAssembly.getViewController()
        
        mainView.delegate = detailView
        
        controller.viewControllers = [UINavigationController(rootViewController: mainView), detailView]
        return controller
    }
}
