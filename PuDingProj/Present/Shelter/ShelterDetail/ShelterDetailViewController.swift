//
//  ShelterDetailViewController.swift
//  PuDingProj
//
//  Created by cho on 5/16/24.
//

import UIKit

class ShelterDetailViewController: BaseViewController {

    let mainView = ShelterDetailView()
    let viewModel = ShelterDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
    }

    override func loadView() {
        view = mainView
    }
}
