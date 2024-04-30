//
//  FundingViewController.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit

class FundingViewController: BaseViewController {

    let mainView = FundingView()
    let viewModel = FundingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        view = mainView
    }


}
