//
//  ShelterListViewController.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShelterListViewController: BaseViewController {

    let mainView = ShelterListView()
    let viewModel = ShelterListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white


    }
    
    override func loadView() {
        view = mainView
    }

    override func bind() {
        let input = ShelterListViewModel.Input(buttonTap: mainView.button.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
    }


}
