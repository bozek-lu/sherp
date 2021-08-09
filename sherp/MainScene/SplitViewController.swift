//
//  SplitViewController.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import UIKit

final class SplitViewController: UISplitViewController {
    private var shouldCollapse = true
    
    override func viewDidLoad() {
        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        super.viewDidLoad()
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Making sure that on the phone, only the app opening lands on main view
        // and any other change will open post details
        defer {
            shouldCollapse = false
        }
        return shouldCollapse
    }
}
