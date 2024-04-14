//
//  MyInfoViewController.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import UIKit

class MyInfoViewController: BaseViewController {

    let mainView = MyInfoView()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func bind() {
        
    }
}
