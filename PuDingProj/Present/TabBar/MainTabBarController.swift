//
//  MainTabBarController.swift
//  PuDingProj
//
//  Created by cho on 4/14/24.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = LoginViewController()
        let vc2 = CommunitiyViewController()
        let vc3 = PostDetailViewController()
    
        vc1.tabBarItem.image = UIImage(systemName: "calendar")
        vc2.tabBarItem.image = UIImage(systemName: "person")
        vc3.tabBarItem.image = UIImage(systemName: "star")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
