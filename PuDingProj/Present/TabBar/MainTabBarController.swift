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

        let vc1 = CommunitiyViewController()
        let vc2 = ShelterListViewController()
        let vc3 = RegistPostViewController()
        let vc4 = FundingViewController()
        let vc5 = MyInfoViewController()
        
        vc3.hidesBottomBarWhenPushed = true
        
        vc1.tabBarItem.image = UIImage(systemName: "calendar")
        vc2.tabBarItem.image = UIImage(systemName: "star")
        vc3.tabBarItem.image = UIImage(systemName: "plus")
        vc4.tabBarItem.image = UIImage(systemName: "heart")
        vc5.tabBarItem.image = UIImage(systemName: "person")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
}
