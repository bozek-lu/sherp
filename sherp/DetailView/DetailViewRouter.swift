//
//  DetailViewRouter.swift
//  sherp
//
//  Created by Łukasz Bożek on 30/08/2021.
//

import UIKit

protocol DetailViewRoutingLogic {
    func routeToImage(with url: URL)
}

final class DetailViewRouter: DetailViewRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToImage(with url: URL) {
        let imageController = ImageViewController(imageURL: url, imageLoader: ImageLoader.shared)
        
        if let navController = viewController?.navigationController {
            navController.pushViewController(imageController, animated: true)
        } else {
            viewController?.present(imageController, animated: true, completion: nil)
        }
    }
}
