//
//  UIViewController+Extension.swift
//  PuDingProj
//
//  Created by cho on 4/22/24.
//

import UIKit

extension UIViewController {
    func moveToAView() {
            guard let navigationController = navigationController else {
                print("This view controller is not embedded in a navigation controller.")
                return
            }
            //navigationController.setViewControllers([LoginViewController()], animated: true)
        navigationController.present(LoginViewController(), animated: true, completion: nil)

        }
}
