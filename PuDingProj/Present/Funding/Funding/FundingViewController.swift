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

        mainView.tableView.register(FundingTableViewCell.self, forCellReuseIdentifier: "FundingTableViewCell")
        view.backgroundColor = .white
//        
//        fundingList
//            .bind(to: mainView.tableView.rx.items(cellIdentifier: "CommunityTableViewCell", cellType: CommunityTableViewCell.self)) { (index, item, cell) in
//                cell.updateUI(item: item)
//                cell.layoutIfNeeded()
//            }
//            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }


}
